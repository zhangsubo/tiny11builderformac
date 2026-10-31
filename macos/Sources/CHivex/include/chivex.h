#ifndef CHIVEX_H
#define CHIVEX_H

#include <stdlib.h>
#include <stdint.h>
#include <errno.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct hive_h hive_h;
typedef size_t hive_node_h;
typedef size_t hive_value_h;

enum hive_type {
    hive_t_REG_NONE = 0,
    hive_t_REG_SZ = 1,
    hive_t_REG_EXPAND_SZ = 2,
    hive_t_REG_BINARY = 3,
    hive_t_REG_DWORD = 4,
    hive_t_REG_DWORD_BIG_ENDIAN = 5,
    hive_t_REG_LINK = 6,
    hive_t_REG_MULTI_SZ = 7,
    hive_t_REG_RESOURCE_LIST = 8,
    hive_t_REG_FULL_RESOURCE_DESCRIPTOR = 9,
    hive_t_REG_RESOURCE_REQUIREMENTS_LIST = 10,
    hive_t_REG_QWORD = 11
};
typedef enum hive_type hive_type;

#define HIVEX_OPEN_VERBOSE 1
#define HIVEX_OPEN_DEBUG   2
#define HIVEX_OPEN_WRITE   4
#define HIVEX_OPEN_UNSAFE  8

struct hive_set_value {
    char *key;
    hive_type t;
    size_t len;
    char *value;
};
typedef struct hive_set_value hive_set_value;

extern hive_h *hivex_open(const char *filename, int flags);
extern int hivex_close(hive_h *h);
extern hive_node_h hivex_root(hive_h *h);
extern char *hivex_node_name(hive_h *h, hive_node_h node);
extern hive_node_h *hivex_node_children(hive_h *h, hive_node_h node);
extern hive_node_h hivex_node_get_child(hive_h *h, hive_node_h node, const char *name);
extern hive_value_h hivex_node_get_value(hive_h *h, hive_node_h node, const char *key);
extern char *hivex_value_string(hive_h *h, hive_value_h val);
extern int32_t hivex_value_dword(hive_h *h, hive_value_h val);
extern int hivex_commit(hive_h *h, const char *filename, int flags);
extern hive_node_h hivex_node_add_child(hive_h *h, hive_node_h parent, const char *name);
extern int hivex_node_delete_child(hive_h *h, hive_node_h node);
extern int hivex_node_set_value(hive_h *h, hive_node_h node, const hive_set_value *val, int flags);

#ifdef __cplusplus
}
#endif

#endif /* CHIVEX_H */
