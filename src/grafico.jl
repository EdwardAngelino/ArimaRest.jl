using  Plots
using DataFrames
#import DataFrames.DataFrame
function grafica(df::DataFrames.DataFrame )

    plot(1:20,exp.(df.Irrest),grid=false,
        ribbon=(exp.(df.Irrest)-exp.(df."I.Inf"),exp.(df."I.Sup")-exp.(df.Irrest)),
        fillalpha=.2,color="orange",label = "Sin Restricciones")

    plot!(1:20,exp.(df.Restr),grid=false,ribbon=(exp.(df.Restr)-exp.(df."R.Inf"),
        exp.(df."R.Sup")-exp.(df.Restr)),fillalpha=.3,color="blue",
        label = "Con Restricciones",title = "Prónosticos exp(val)")
end
