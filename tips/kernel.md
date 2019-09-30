
# to build a kvmconfig
x86_64_defconfig kvmconfig

# to prevent 

# To enable/disable printk dynamically 
pr_debug 
https://lwn.net/Articles/434833/
cat /sys/kernel/debug/dynamic_debug/control 

# to build compile_commands.json
Run scripts/gen_compile_commands.py
https://github.com/MaskRay/ccls/issues/299
