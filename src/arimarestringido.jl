export restringido
function restringido(eqNabla::String,eqTheta::String,eqPhi::String, σ2::Float64,  #datos del modelo
                     H::Integer, EYTF::Array, Y::Array, C::Array,    # datos de la restriccion
                     salidacsv::String)


    L = symbols("L")

    z1,z2,z3,z4,z5,z6,z7,z8,z9,z10,z11,z12,z13,z14,z15,z16,z17,z18,z19,z20,z21,z22,z23,z24,
    z25,z26,z27,z28,z29,z30,z31,z32,z33,z34,z35,z36   =
    symbols("z1,z2,z3,z4,z5,z6,z7,z8,z9,z10,z11,z12,z13,z14,z15,z16,z17,z18,z19,z20,z21,z22,z23,z24,
    z25,z26,z27,z28,z29,z30,z31,z32,z33,z34,z35,z36");  # ψ1

    chi2_95 = [3.8415,5.9915,7.8147,9.4877,11.0705,12.5916]

    # Datos del modelo ARIMA
    #σ2  =  0.0002833  # desviacion

    #Ecuacion de regresion
    #Θ=1-θ1*L
    Θ=sympify(eqTheta)

    #Φ=(1 - L - ϕ12*L^12)  # aproximacion (1-L)(1-f12*L^12)
    #Φ= (1-L)*(1-ϕ12*L^12)
    Φ= sympify(eqNabla)*sympify(eqPhi)
    # definicion del vector zi
    #zi=(1+z1*L+z2*L^2+z3*L^3+z4*L^4+z5*L^5+z6*L^6+z7*L^7+z8*L^8)
    cad="1"; for i=1:H cad = cad * "+z$(i)*L^$(i)" end

    #zi=eval(Meta.parse(cad))
    zi=sympify(cad)
    poli = expand(zi*Φ-Θ)

    coef=[poli.coeff(L^i) for i in 1:H]

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

#datos conocidos
       #Y=[   12*log(43691.09*1.085/12) - log(3847.741526)-log(3713.569865)-log(3954.616134) - log(3748.112726)    #  2020
#             12*log(43691.09*1.085*1.06/12)           #  2021
#       ]

       χ2 = chi2_95[length(Y)]  # chi cuadrada  para 3

#       C = [1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0
#            0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1
#            ]

            #incertidumbre
            #4.5%/6% = 3/4 entonces la nueva tasa objetivo 2.6% = 3.4%*3/4 (3.4% es lo que se obtiene sin restriccion)
            #Pr{Y1 < 0.045} = 0.95 la probabilidad que sea menor de 4.5%

            #uu = symbols("uu")
            #u1 = solve(0.045-0.026-1.645*uu^0.5,uu)  #en el texto de victor guerrero 0.00014

            U = zeros(length(Y),length(Y));

            #Calculo de matrices

            A=(Ψ*transpose(Ψ))*transpose(C)*inv(C*Ψ*transpose(Ψ)*transpose(C)+U)

            #datos inician en mayo 2020 = N+1
            #EYTF = [
            #8.244000196
            #8.203459715
            #8.22613888
            #8.227831797
            #8.196449529
            #8.250765523
            #8.23644938
            #8.272428234
            #8.284801839
            #8.253954031
            #8.30861364
            #8.262003317
            #8.275033116
            #8.239797668
            #8.259508535
            #8.260979687
            #8.233704219
            #8.280911853
            #8.268469169
            #8.29973947
            #]

            #Intervalo de confianza sin restricciones 90%
            # 1-a, a,/2, za/2 => 0.9,0.05,1.645   0.95,0.025,1.96   0.99,0.005,2.575
            cov0=σ2*Ψ*transpose(Ψ)
            errest0= [real(sqrt(complex(cov0[i,i]))) for i in 1:H];  # raiz negativa por aproximacion...

            Total0 = [EYTF  EYTF-1.645*errest0  EYTF+1.645*errest0]

            #Correccion de la proyeccion
            TYf = EYTF + A*(Y-C*EYTF)

            #VAlidacion del ajuste
            ey=Y-C*EYTF
            k_calc=transpose(ey)*inv(C*Ψ*transpose(Ψ)*transpose(C)+U)*ey/σ2
            println("Kcal < χ2\n","$k_calc < $χ2\n")
            k_calc < χ2  # es valida la restriccion

            #intervalos de confianza
            cov=σ2*Ψ*transpose(Ψ)*transpose(I-A*C)

            errest= [real(sqrt(complex(cov[i,i]))) for i in 1:H];
            I_sup= TYf+1.645*errest  # 1-a, a,/2, za/2 => 0.9,0.05,1.645   0.95,0.025,1.96   0.99,0.005,2.575
            I_inf= TYf-1.645*errest;

            TotalR = [TYf  I_inf  I_sup]
            df = DataFrame([Total0 TotalR])
            header = ["Irrest", "I.Inf", "I.Sup","Restr", "R.Inf", "R.Sup"]
            rename!(df,header)

            #imprimir en CSV
            CSV.write(salidacsv,  df )     #writeheader=false)

            plot(1:20,exp.(df.Irrest),grid=false,
               ribbon=(exp.(df.Irrest)-exp.(df."I.Inf"),exp.(df."I.Sup")-exp.(df.Irrest)),
               fillalpha=.2,color="orange",label = "Sin Restricciones")

            plot!(1:20,exp.(df.Restr),grid=false,ribbon=(exp.(df.Restr)-exp.(df."R.Inf"),
               exp.(df."R.Sup")-exp.(df.Restr)),fillalpha=.3,color="blue",
               label = "Con Restricciones",title = "Prónosticos exp(val)")


            return df
end
