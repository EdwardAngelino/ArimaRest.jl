using SymPy, DelimitedFiles
function leedatostxt(archivo::String   )
    data = readdlm(archivo,'=','\n'; comments=true, comment_char='#');
    for i =1:size(data)[1]  data[i]=rstrip(data[i]) end ;  #quita los espacios antes del "=" en las definiciones

    i=findall(x->x=="diff", data)[][1] ;
    eqnabla=sympify(data[i,2])
    i=findall(x->x=="theta", data)[][1] ;
    eqtheta=sympify(data[i,2])
    i=findall(x->x=="phi", data)[][1] ;
    eqphi=sympify(data[i,2])
    i=findall(x->x=="sigma2", data)[][1] ;
    data[i,2]= string(data[i,2])       #add bugg  
    sigma2= eval(Meta.parse(data[i,2]));


    C=[];
    i=findall(x->x=="C", data)[][1]
    rstrip(lstrip(data[i,2])) != "[" ? data[i]=lstrip(rstrip(lstrip(data[i,2])),'[') : i +=1

    while (isempty(findall(x->x==']', data[i])))
       t = Meta.parse.(split(data[i]))
       # println(t')
        push!(C,t')
        i += 1
    end
    t = Meta.parse.(split(rstrip(data[i],']'))) ;
    !(isempty(findall(x->x==']', data[i]))) && !isempty(t) ? (  push!(C,t') ) : 0
    C=vcat(C...)

    Y=[];
    i=findall(x->x=="Y", data)[][1]
    rstrip(lstrip(data[i,2])) != "[" ? data[i]=lstrip(rstrip(lstrip(data[i,2])),'[') : i +=1
    while (isempty(findall(x->x==']', data[i])))
        data[i]= string(data[i])       #add bugg  
        t = eval(Meta.parse(data[i]))  #solo este vector puede leer operaciones
        push!(Y,t)
        i += 1
    end
    t = eval(Meta.parse(rstrip(data[i],']')))
    !(isempty(findall(x->x==']', data[i])))  && !isnothing(t) ?  push!(Y,t)  : 0


    EYTF=[]; AT=[];
    i=findall(x->x=="seriesf", data)[][1]
    rstrip(lstrip(data[i,2])) != "[" ? data[i]=lstrip(rstrip(lstrip(data[i,2])),'[') : i +=1
    while (isempty(findall(x->x==']', data[i])))
        t = Meta.parse.(split(data[i]))
        push!(EYTF,t[1])
        push!(AT,t[2])
        i += 1
    end
    t = Meta.parse.(split(rstrip(data[i],']')))  #evita campo vacio de vector
    !(isempty(findall(x->x==']', data[i])))  && !isempty(t) ?  ( push!(EYTF,t[1]); push!(AT,t[2]) ) : 0;

    datos = Dict(:eqDiff => eqnabla, :eqtheta => eqtheta, :eqphi => eqphi, :sigma2 =>sigma2,
    :C => C, :Y => Y, :EYTF => EYTF, :AT => AT);

    return datos
end
