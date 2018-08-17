/* Copyright (c) 2016 Facebook
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of version 2 of the GNU General Public
 * License as published by the Free Software Foundation.
 */

/* see https://stackoverflow.com/questions/47895179/how-to-build-bpf-program-out-of-the-kernel-tree
 * clang -O2 -emit-llvm -c test_ebpf_tc.c -o - | llc -march=bpf -filetype=obj -o bpf.o
 * Set $dev to `make INSTALL_HDR_PATH=dest headers_install`
 * 
 * Look in https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/samples/bpf/Makefile
 *
 THIS WORKED !!!
nix-shell -p llvm_4 clang
clang  -O2 -emit-llvm -c test_ebpf_tc.c -v -I${dev}/build/dest -I${dev}/build/include -I${dev}/build/arch/x86/include/uapi -I${dev}/arch/x86/include| llc -march=bpf -filetype=obj -o bpf.o
 */
#define KBUILD_MODNAME "foo"

#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/if_packet.h>
#include <linux/ip.h>
#include <linux/in.h>
#include <linux/tcp.h>
#include <linux/filter.h>
#include <linux/pkt_cls.h>
/* copied from samples/bpf/bpf_helpers.h */
#include "bpf_helpers.h" 


/* for offsetof */
#include <stddef.h> 

#define IP_TCP 	6
#define ETH_HLEN 14

struct Key {
  unsigned char p[255];
};

#define SEC(NAME) __attribute__((section(NAME), used))
#define PIN_GLOBAL_NS		2
struct bpf_elf_map {
	__u32 type;
	__u32 size_key;
	__u32 size_value;
	__u32 max_elem;
	__u32 flags;
	__u32 id;
	__u32 pinning;
};

/* copy of 'struct ethhdr' without __packed */
struct eth_hdr {
	unsigned char   h_dest[ETH_ALEN];
	unsigned char   h_source[ETH_ALEN];
	unsigned short  h_proto;
};


struct bpf_elf_map SEC("maps") map = {
        .type = BPF_MAP_TYPE_ARRAY,
        .size_key = sizeof(int),
        .size_value = sizeof(int),
        .pinning = PIN_GLOBAL_NS,
        .max_elem = 1,
};

/*inline int bpf_create_map(enum bpf_map_type map_type,
		unsigned int key_size,
		unsigned int value_size,
		unsigned int max_entries)
{
	union bpf_attr attr = {
		.map_type    = map_type,
		.key_size    = key_size,
		.value_size  = value_size,
		.max_entries = max_entries
	};

	return bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
}*/

#define DEBUG 0

#ifdef  DEBUG
/* Only use this for debug output. Notice output from bpf_trace_printk()
 *  * end-up in /sys/kernel/debug/tracing/trace_pipe
 *   */
#define bpf_debug(fmt, ...)						\
			({							\
			char ____fmt[] = fmt;				\
			bpf_trace_printk(____fmt, sizeof(____fmt),	\
			##__VA_ARGS__);			\
			})
#else
#define bpf_debug(fmt, ...) { } while (0)
#endif

#define FIN 0
#define SYN 1
#define RST 2
#define PSH 3
#define ACK 4
#define URG 5
#define ECE 6
#define CWR 7

int get_flag(__u8 flags, int flag) {
	return flags & (1 << flag);
}

SEC("action") int handle_ingress(struct __sk_buff *skb)
{
	struct tcphdr *tcp = (struct tcphdr *) skb + (ETH_HLEN + sizeof(struct iphdr));
	int key = 0, *seen;
	seen = bpf_map_lookup_elem(&map, &key);
	if(!seen) {
		int val = 0;
		if(bpf_map_update_elem(&map, &key, &val, BPF_NOEXIST))
			return TC_ACT_OK;
	}
	seen = bpf_map_lookup_elem(&map, &key);
	if(!seen)
		return TC_ACT_OK;

	if(!tcp)
		return TC_ACT_OK;

	/* sizeof(struct tcphdr); */

	/* __u16 *addr = (__u16 *) (&(tcp -> ack_seq) + 1); */
	__u64 flags = (__u64) load_byte(skb, ETH_HLEN + sizeof(struct iphdr) + offsetof(struct tcphdr, ack_seq) + 4 + 1);
	//__u16 flags = *addr;//*((__u16 *) ((0 + 1)));
	if( get_flag(flags, SYN)) {
		int val = 0;
		*seen = 0;
		bpf_debug("RESET SEEN\n");
		bpf_map_update_elem(&map, &key, &val, BPF_EXIST);
	}
	//if (tcp -> fin && !*seen) {
	// We here only handle the little endian case
        
	//bpf_debug("ack = %x\n", tcp -> ack_seq);
        // fin is at the 1st position of the byte in little endian
	if (0 && get_flag(flags, PSH) && get_flag(flags, FIN) /*|| get_flag(flags, PSH)*/ /*&& !*seen*/) { // tail drop
		*seen = 1;
		bpf_debug("DROP, PSH: %x\n", get_flag(flags, PSH));
                bpf_debug("DROP, FIN: %x\n", get_flag(flags, FIN));

		int val = 1;
		bpf_map_update_elem(&map, &key, &val, BPF_EXIST);
		return TC_ACT_SHOT;
	} else if (!get_flag(flags, SYN) && !*seen) {
		__u8 off = (__u8) load_byte(skb, ETH_HLEN + sizeof(struct iphdr) + offsetof(struct tcphdr, ack_seq) + 4) & 0x0F;
		int header_size = off*4;
		int packet_len = skb -> len - (ETH_HLEN + sizeof(struct iphdr) + header_size);
		if(packet_len < 1200 && packet_len > 250) {
			// this is the tail
			bpf_debug("TAIL DROP, %d\n", packet_len);
			int val = 1;
                	bpf_map_update_elem(&map, &key, &val, BPF_EXIST);
			return TC_ACT_SHOT;
		} //else
			//bpf_debug("NO DROP: %d\n", packet_len);
	}
	return TC_ACT_OK;

}

char _license[] SEC("license") = "GPL";
