# ArimaRest.jl
ArimaRest.jl es una libreria programada por **Edward Angelino** para poder corregir y ajustar los pronósticos de ARIMA univariantes, con información externa al modelo. Esta información es ingresada como restricciones a los valores unicos o a las agrupaciones de valores (Ejemplo tasas de años en el caso de meses), de esta manera además, se establece una encadenacion temporal. La validacion de las restricciones impuestas se mide atravez del indicador <img src="https://render.githubusercontent.com/render/math?math=K_{calc} < \chi^2_m">, donde <img src="https://render.githubusercontent.com/render/math?math=m"> son los grados de libertad de la restricción. Esta indicador esta relacionado con el intervalo de confianza del pronóstico del modelo ARIMA evaluado.

El principal beneficio de restringir las estimaciones es la reduccion de la incertidumbre del modelo, acotando los intervalos de confianza, debido a la informacion adicional y encontrando los  valores intermedios ajustados  que cumplen con la restriccion impuesta.


El cálculo es algebraico y matricial, para lo cual se ha creado dos funciones:


--
<img src="https://render.githubusercontent.com/render/math?math=restringe(eq\nabla, eq\Theta,eq\Phi,\sigma^2,EY_{tf},Y,C,out)">

donde:

<img src="https://render.githubusercontent.com/render/math?math=eq\nabla"> : Ecuación de retados en funcion de **L**, si tambien tiene componente estacion se muliplica.

<img src="https://render.githubusercontent.com/render/math?math=eq\Theta"> : Ecuación de medias moviles del modelo en funcion de **L**.

<img src="https://render.githubusercontent.com/render/math?math=eq\Phi"> : Ecuación de autoregresivos del modelo en funcion de **L**

<img src="https://render.githubusercontent.com/render/math?math=\sigma^2"> : Desviación estandar al cuadrado del modelo

<img src="https://render.githubusercontent.com/render/math?math=EY_{tf}"> :  Valores del pronóstico que se van a restringir o modificar.

<img src="https://render.githubusercontent.com/render/math?math=Y"> :  Vector de objetivos de tal manera que se cumple la ecuación   <img src="https://render.githubusercontent.com/render/math?math=CZ_F=Y">

<img src="https://render.githubusercontent.com/render/math?math=C"> : Vector que multiplica a los resultados de tal forma que se cumple la ecuación <img src="https://render.githubusercontent.com/render/math?math=CZ_F=Y">

<img src="https://render.githubusercontent.com/render/math?math=out"> : archivo .csv de salida

--
<img src="https://render.githubusercontent.com/render/math?math=grafica(dt,f)">

  donde:

<img src="https://render.githubusercontent.com/render/math?math=dt">  :  DataFrame que contiene los resultados del	cálculo <img src="https://render.githubusercontent.com/render/math?math=[Irrest, I.Inf, I.Sup,Restr, R.Inf, R.Sup]">

<img src="https://render.githubusercontent.com/render/math?math=f">  :  flag que permite graficar 1:en Log y 0:en niveles.

[![Build Status](https://travis-ci.com/EdwardAngelino/ArimaRest.jl.svg?branch=master)](https://travis-ci.com/EdwardAngelino/ArimaRest.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/EdwardAngelino/ArimaRest.jl?svg=true)](https://ci.appveyor.com/project/EdwardAngelino/ArimaRest-jl)
[![Coverage](https://codecov.io/gh/EdwardAngelino/ArimaRest.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/EdwardAngelino/ArimaRest.jl)
