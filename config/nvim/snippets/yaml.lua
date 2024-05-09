return {
s({
    trig = "gfoldstart",
    namr = "gitlab fold header",
    dscr = "Start a new gitlab CI fold"
}, {
 -- echo -e "\\e[0Ksection_start:`date +%s`:typecheck-and-warning[collapsed=false]\\r\\e[0KCheck for warnings"
 t([[echo -e "\\e[0Ksection_start:`date +%s`:typecheck-and-warning[collapsed=false]\\r\\e[0KCheck for warnings"]])
}),

s({
    trig = "gfoldend",
    namr = "gitlab fold footer",
    dscr = "End a gitlab CI fold"
}, {
 t([[echo -e "\\e[0Ksection_end:`date +%s`:typecheck-and-warning\\r\\e[0K"]])
})

}

