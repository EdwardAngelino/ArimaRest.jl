using  Plots
using DataFrames
#import DataFrames.DataFrame
function grafica(df::DataFrames.DataFrame , f::Integer)

if f==1
    plot(1:H,exp.(df.Irrest),grid=false,
        ribbon=(exp.(df.Irrest)-exp.(df."I.Inf"),exp.(df."I.Sup")-exp.(df.Irrest)),
        fillalpha=.2,color="orange",label = "Sin Restricciones")

    plot!(1:H,exp.(df.Restr),grid=false,ribbon=(exp.(df.Restr)-exp.(df."R.Inf"),
        exp.(df."R.Sup")-exp.(df.Restr)),fillalpha=.3,color="blue",
        label = "Con Restricciones",title = "Prónosticos exp(val)")
else
    plot(1:H,(df.Irrest),grid=false,
        ribbon=((df.Irrest)-(df."I.Inf"),(df."I.Sup")-(df.Irrest)),
        fillalpha=.2,color="orange",label = "Sin Restricciones")

    plot!(1:H,(df.Restr),grid=false,ribbon=((df.Restr)-(df."R.Inf"),
        (df."R.Sup")-(df.Restr)),fillalpha=.3,color="black",
        label = "Con Restricciones",title = "Prónosticos (val)")

end
end
