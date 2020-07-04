# ArimaRest.jl
ArimaRest.jl es una libreria programada por **Edward Angelino** para poder corregir y ajustar los pronósticos de ARIMA univariantes, con información externa al modelo. Esta información es ingresada como restricciones a los valores unicos o a las agrupaciones de valores (Ejemplo tasas de años en el caso de meses), de esta manera además, se establece una encadenacion temporal. La validacion de las restricciones impuestas se mide atravez del indicador <img src="https://render.githubusercontent.com/render/math?math=K_{calc} < \chi^2_m">, donde <img src="https://render.githubusercontent.com/render/math?math=m"> son los grados de libertad de la restricción. Esta indicador esta relacionado con el intervalo de confianza del pronóstico del modelo ARIMA evaluado.


<img src="https://render.githubusercontent.com/render/math?math=\phi\left(L\right)\varPhi\left(L_{s}\right)\nabla^{d}\nabla^{D}\centerdot Z_{t}=\theta\left(L\right)\Theta\left(L_{s}\right)a_{t}">


<img src="https://render.githubusercontent.com/render/math?math=\begin{multline*}\left(1-\phi_{1}L-\phi_{2}L^{2}-...-\phi_{p}L^{p}\right)\left(1-\varPhi_{1}L_{s}-\varPhi_{2}L_{s}^{2}-...-\varPhi_{P}L_{s}^{P}\right)\left(1-L\right)^{d}\left(1-L^{s}\right)^{D}Z_{t}\\=\left(1\dotplus\theta_{1}L\dotplus\theta_{2}L^{2}\dotplus...\dotplus\theta_{q}L^{q}\right)\left(1\dotplus\Theta_{1}L_{s}\dotplus\Theta_{2}L_{s}^{2}\dotplus...\dotplus\Theta_{Q}L_{s}^{Q}\right)a_{t}\end{multline*}">


El principal beneficio de restringir las estimaciones es la reduccion de la incertidumbre del modelo, acotando los intervalos de confianza, debido a la informacion adicional y encontrando los  valores intermedios ajustados  que cumplen con la restriccion impuesta.




El cálculo es algebraico y matricial, para lo cual se ha creado  funciones de lectura, proceso y grafico:

--

<img src="https://render.githubusercontent.com/render/math?math=dic=leedatostxt(archivo)">

donde:

<img src="https://render.githubusercontent.com/render/math?math=dic"> : Variable del tipo Dic donde se almacenara toda la informacion del archivo texto.

<img src="https://render.githubusercontent.com/render/math?math=archivo"> : Archivo de texto plano donde se ingresan los datos para el cálculo. Tiene el siguiente formato:

	#Datos_Modelo
	diff  = (1-L)*(1-L^12)
	theta = (1-0.213503*L-0.210997*L^2)*(1-0.903785*L^12)
	phi = 1
	sigma2 = 0.011956^2   # soporta operaciones apesar que es un numero

	#Objetivos
	C = [
     1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 ]

	Y = [
	  12*log(42803.322445*1.0294/12) - 41.01134993     #  2020 - ene:may2020
      12*log(42803.322445*1.0294*1.0061/12)            #  2021
      12*log(42803.322445*1.0294*1.0061*1.0367/12)  ]  #  2022

	#Datos a ajustar  [serie_sa atipicos]
	seriesf = [
		8.154973727	-0.211095349
		8.18563597	-0.159745649
		8.19698976	-0.12380086
		8.175109724	-0.098639507
		8.21674547	-0.08102656
		8.200111952	-0.068697497
		...          	.....
		8.277733291	-0.039935196
		8.316698287	-0.039933542]




--

<img src="https://render.githubusercontent.com/render/math?math=df=restringe(datos,salida)">

donde:

<img src="https://render.githubusercontent.com/render/math?math=datos"> : variable Dic que contiene  los datos para el cálculo

<img src="https://render.githubusercontent.com/render/math?math=salida"> : archivo .csv de salida

--
<img src="https://render.githubusercontent.com/render/math?math=grafica(dt,f)">

  donde:

<img src="https://render.githubusercontent.com/render/math?math=dt">  :  DataFrame que contiene los resultados del cálculo sin considerar atipicos <img src="https://render.githubusercontent.com/render/math?math=[Irrest, I.Inf, I.Sup,Restr, R.Inf, R.Sup]">

<img src="https://render.githubusercontent.com/render/math?math=f">  :  flag que permite graficar 1:en Log y 0:en niveles.

[![Build Status](https://travis-ci.com/EdwardAngelino/ArimaRest.jl.svg?branch=master)](https://travis-ci.com/EdwardAngelino/ArimaRest.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/EdwardAngelino/ArimaRest.jl?svg=true)](https://ci.appveyor.com/project/EdwardAngelino/ArimaRest-jl)
[![Coverage](https://codecov.io/gh/EdwardAngelino/ArimaRest.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/EdwardAngelino/ArimaRest.jl)
