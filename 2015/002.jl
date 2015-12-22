function compute(lwh)
    s1 = lwh[1] * lwh[2]
    s2 = lwh[2] * lwh[3]
    s3 = lwh[1] * lwh[3]
    
    min(s1, s2, s3) + mapreduce(x -> x * 2, +, [s1, s2, s3])
end

function process_line(l)
    compute(map(v -> parse(Int, v), split(l, "x"))) 
end

println(mapreduce(process_line, +, eachline(STDIN))) 
