/* 
Simple program to mount /system partition ro
Author: nobodyAtall @ xda 
Based on: mtdutils by CodeAurora
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/mount.h>  // for _IOW, _IOR, mount()
#include <sys/stat.h>
#include <mtd/mtd-user.h>
#undef NDEBUG
#include <assert.h>

#include "mtdutils.h"
#define MAX_LEN_SINGLE_LINE 1024

struct MtdReadContext {
    const MtdPartition *partition;
    char *buffer;
    size_t consumed;
    int fd;
};

struct MtdWriteContext {
    const MtdPartition *partition;
    char *buffer;
    size_t stored;
    int fd;

    off_t* bad_block_offsets;
    int bad_block_alloc;
    int bad_block_count;
};

typedef struct {
    MtdPartition *partitions;
    int partitions_allocd;
    int partition_count;
} MtdState;

static MtdState g_mtd_state = {
    NULL,   // partitions
    0,      // partitions_allocd
    -1      // partition_count
};

#define MTD_PROC_FILENAME   "/proc/mtd"

int
mtd_scan_partitions()
{
    char buf[2048];
    const char *bufp;
    int fd;
    int i;
    ssize_t nbytes;

    if (g_mtd_state.partitions == NULL) {
        const int nump = 32;
        MtdPartition *partitions = malloc(nump * sizeof(*partitions));
        if (partitions == NULL) {
            errno = ENOMEM;
            return -1;
        }
        g_mtd_state.partitions = partitions;
        g_mtd_state.partitions_allocd = nump;
        memset(partitions, 0, nump * sizeof(*partitions));
    }
    g_mtd_state.partition_count = 0;

    /* Initialize all of the entries to make things easier later.
     * (Lets us handle sparsely-numbered partitions, which
     * may not even be possible.)
     */
    for (i = 0; i < g_mtd_state.partitions_allocd; i++) {
        MtdPartition *p = &g_mtd_state.partitions[i];
        if (p->name != NULL) {
            free(p->name);
            p->name = NULL;
        }
        p->device_index = -1;
    }

    /* Open and read the file contents.
     */
    fd = open(MTD_PROC_FILENAME, O_RDONLY);
    if (fd < 0) {
        goto bail;
    }
    nbytes = read(fd, buf, sizeof(buf) - 1);
    close(fd);
    if (nbytes < 0) {
        goto bail;
    }
    buf[nbytes] = '\0';

    /* Parse the contents of the file, which looks like:
     *
     *     # cat /proc/mtd
     *     dev:    size   erasesize  name
     *     mtd0: 00080000 00020000 "bootloader"
     *     mtd1: 00400000 00020000 "mfg_and_gsm"
     *     mtd2: 00400000 00020000 "0000000c"
     *     mtd3: 00200000 00020000 "0000000d"
     *     mtd4: 04000000 00020000 "system"
     *     mtd5: 03280000 00020000 "userdata"
     */
    bufp = buf;
    while (nbytes > 0) {
        int mtdnum, mtdsize, mtderasesize;
        int matches;
        char mtdname[64];
        mtdname[0] = '\0';
        mtdnum = -1;

        matches = sscanf(bufp, "mtd%d: %x %x \"%63[^\"]",
                &mtdnum, &mtdsize, &mtderasesize, mtdname);
        /* This will fail on the first line, which just contains
         * column headers.
         */
        if (matches == 4) {
            MtdPartition *p = &g_mtd_state.partitions[mtdnum];
            p->device_index = mtdnum;
            p->size = mtdsize;
            p->erase_size = mtderasesize;
            p->name = strdup(mtdname);
            if (p->name == NULL) {
                errno = ENOMEM;
                goto bail;
            }
            g_mtd_state.partition_count++;
        }

        /* Eat the line.
         */
        while (nbytes > 0 && *bufp != '\n') {
            bufp++;
            nbytes--;
        }
        if (nbytes > 0) {
            bufp++;
            nbytes--;
        }
    }

    return g_mtd_state.partition_count;

bail:
    // keep "partitions" around so we can free the names on a rescan.
    g_mtd_state.partition_count = -1;
    return -1;
}

const MtdPartition *
mtd_find_partition_by_name(const char *name)
{
    if (g_mtd_state.partitions != NULL) {
        int i;
        for (i = 0; i < g_mtd_state.partitions_allocd; i++) {
            MtdPartition *p = &g_mtd_state.partitions[i];
            if (p->device_index >= 0 && p->name != NULL) {
                if (strcmp(p->name, name) == 0) {
                    return p;
                }
            }
        }
    }
    return NULL;
}

int
mtd_mount_partition(const MtdPartition *partition, const char *mount_point,
        const char *filesystem, int read_only)
{
    const unsigned long flags = MS_NOATIME | MS_NODEV | MS_NODIRATIME;
    char devname[64];
    int rv = -1;

    sprintf(devname, "/dev/block/mtdblock%d", partition->device_index);
    if (!read_only) {
	printf ("mounting %s on %s using fs %s and flags %d\n", devname, mount_point, filesystem);
        rv = mount(devname, mount_point, filesystem, flags, NULL);
        if (rv < 0) {
        	printf( "Error: %s\n", strerror( errno ) );
        	// remount rw
        	rv = mount(devname, mount_point, filesystem, flags | MS_REMOUNT, NULL);
        }
    }
    if (read_only || rv < 0) {
	printf ("mounting %s on %s using fs %s and flags %d\n", devname, mount_point, filesystem);
        rv = mount(devname, mount_point, filesystem, flags | MS_RDONLY, 0);
        if (rv < 0) {
            printf("Failed to mount %s on %s: %s\n",
                    devname, mount_point, strerror(errno));
        } else {
            printf("Mount %s on %s read-only\n", devname, mount_point);
        }
    }
#if 1   //TODO: figure out why this is happening; remove include of stat.h
    if (rv >= 0) {
        /* For some reason, the x bits sometimes aren't set on the root
         * of mounted volumes.
         */
        struct stat st;
        rv = stat(mount_point, &st);
        if (rv < 0) {
            return rv;
        }
        mode_t new_mode = st.st_mode | S_IXUSR | S_IXGRP | S_IXOTH;
        if (new_mode != st.st_mode) {
printf("Fixing execute permissions for %s\n", mount_point);
            rv = chmod(mount_point, new_mode);
            if (rv < 0) {
                printf("Couldn't fix permissions for %s: %s\n",
                        mount_point, strerror(errno));
            }
        }
    }
#endif
    return rv;
}

int cmd_mtd_mount_partition(const char *partition, const char *mount_point, const char *filesystem, int read_only)
{
    mtd_scan_partitions();
    const MtdPartition *p;
    p = mtd_find_partition_by_name(partition);
    if (p == NULL) {
        return -1;
    }
    return mtd_mount_partition(p, mount_point, filesystem, read_only);
}

int main() {
	printf ("Mounting /system partition to /minicm/system\n");
	cmd_mtd_mount_partition("system", "/minicm/system", "yaffs2", 0);
	return 0;
}

