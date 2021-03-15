export restringido
#function restringido(eqNabla::String,eqTheta::String,eqPhi::String, σ2::Float64,  #datos del modelo
#                     EYTF::Array, Y::Array, C::Array,    # datos de la restriccion
#                     salidacsv::String)

function restringido( datos::Dict   , salidacsv::String)
    @syms L ;  #B : operador retardo
    # ψ1
    @syms z1 z2 z3 z4 z5 z6 z7 z8 z9 z10 z11 z12 z13 z14 z15 z16 z17 z18 z19 z20 ;
    @syms z21 z22 z23 z24 z25 z26 z27 z28 z29 z30 z31 z32 z33 z34 z35 z36 z37 z38 z39 z40;
    @syms z41 z42 z43 z44 z45 z46 z47 z48 z49 z50 z51 z52 z53 z54 z55 z56 z57 z58 z59 z60;

    #lectura del diccionario

    EYTF = datos[:EYTF]
    AT = datos[:AT]
    C= datos[:C]
    Y = datos[:Y]
    σ2 = datos[:sigma2]

    chi2_95 = [3.8415,5.9915,7.8147,9.4877,11.0705,12.5916]

    H = length(EYTF)   #tamaño del vector que se ingreso
   global H
    # Datos del modelo ARIMA
    #σ2  =  0.0002833  # desviacion

    #Ecuacion de regresion
    #Θ=1-θ1*L

    Θ=datos[:eqtheta]

    #Φ=(1 - L - ϕ12*L^12)  # aproximacion (1-L)(1-f12*L^12)
    #Φ= (1-L)*(1-ϕ12*L^12)
    Φ= datos[:eqDiff]*datos[:eqphi]

    eq = Θ/Φ
    global eq

    # definicion del vector zi
    #zi=(1+z1*L+z2*L^2+z3*L^3+z4*L^4+z5*L^5+z6*L^6+z7*L^7+z8*L^8)
    cad="1"; for i=1:H cad = cad * "+z$(i)*L^$(i)" end

    #zi=eval(Meta.parse(cad))
    zi=sympify(cad)
    poli = expand(zi*Φ-Θ)

    coef=[poli.coeff(L^i) for i in 1:H]
    global coef
    #Calculo de la matriz ZI

#Resuelve algebraicamente las ecuaciones de cada coeficiente
    zie = [solve(poli.coeff(L^i),"z$i") for i in 1:H]

#Reemplaza de manera recursiva los valores desde el primero al ultimo
    sus=[]
    for i = 1: H-1
        push!(sus,("z$i",zie[i][1]))
        zie[i+1][1]=zie[i+1][1].subs(sus)
    end
#Forma la matriz ZI
#using LinearAlgebra
       Ψ=I+zeros(H,H)
       for j=1:H for i=j+1:H Ψ[i,j] = zie[i-j][1] end end
       global Ψ
#datos conocidos

       χ2 = chi2_95[length(Y)]  # chi cuadrada  para 3


            U = zeros(length(Y),length(Y));

            #Calculo de matrices

            A=(Ψ*transpose(Ψ))*transpose(C)*inv(C*Ψ*transpose(Ψ)*transpose(C)+U)

            cov0=σ2*Ψ*transpose(Ψ)
            errest0= [real(sqrt(complex(cov0[i,i]))) for i in 1:H];  # raiz negativa por aproximacion...
            global errest0
            Total0 = [EYTF  EYTF-1.645*errest0  EYTF+1.645*errest0]

            #Correccion de la proyeccion
            TYf = EYTF + A*(Y-C*EYTF)

            #VAlidacion del ajuste
            ey=Y-C*EYTF
            k_calc=transpose(ey)*inv(C*Ψ*transpose(Ψ)*transpose(C)+U)*ey/σ2
            println("Kcal < χ2\n","$k_calc < $χ2\n")
            k_calc < χ2  # es valida la restriccion
            global k_calc
            #intervalos de confianza
            cov=σ2*Ψ*transpose(Ψ)*transpose(I-A*C)

            errest= [real(sqrt(complex(cov[i,i]))) for i in 1:H];
            global errest
            I_sup= TYf+1.645*errest  # 1-a, a,/2, za/2 => 0.9,0.05,1.645   0.95,0.025,1.96   0.99,0.005,2.575
            I_inf= TYf-1.645*errest;

            TotalR = [TYf  I_inf  I_sup]
            df = DataFrame([Total0 TotalR])
            header = ["Irrest", "I.Inf", "I.Sup","Restr", "R.Inf", "R.Sup"]
            rename!(df,header)

            df=df.+AT
            #imprimir en CSV
            CSV.write(salidacsv,  df )     #writeheader=false)
            global df

            return df
end
