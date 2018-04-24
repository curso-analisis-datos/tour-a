# guia https://www.youtube.com/watch?v=w_aUCJHRv0Y
require(MASS)

## Preparamos el set de datos
#perfil.scale <- as.data.frame(scale(perfil[,c(2,14,15)])) # escalar los datos
perfil.scale <- as.data.frame((perfil[,c(2,14,15)])) # sin escalar los datos

str(perfil.scale)
ncol(perfil.scale)
summary(perfil.scale)

head(perfil.scale)

#perfil.scale.limpios <- perfil.scale[complete.cases(perfil.scale),]
#str(perfil.scale.limpios)

##Creamos los clusters

set.seed(10) # fijar semilla
perfil.km <- kmeans(perfil.scale, centers = 4) # Realizamos clustering nstart=20
names(perfil.km) # contenido del objeto

perfil.km$centers # centroides
table(perfil.km$cluster, perfil.scale$Sexo)

perfil.km$cluster # asginacion observaciones a clusters
perfil.km$totss # inercia total
perfil.km$betweenss # inercia inter grupos
perfil.km$withinss # inercia intra grupos
perfil.km$tot.withinss # inervcia intra grupos (total)

## Determinar un número 1de clusters optimo
sumbt <- kmeans(perfil.scale, centers = 1)$betweenss
for (i in 2:4) {
  sumbt[i]<- kmeans(perfil.scale, centers = 1)$betweenss
}
plot(1:4, sumbt, type = "b", xlab = "num de clusters", ylab = "suma de cuadrados inter grupos")

## Inspeccionando los resultados
plot(perfil.scale$Permanecia, perfil.scale$Gasto, col= perfil.km$cluster, xlab = "perm", ylab = "gasto")
aggregate(perfil.scale, by = list(perfil.km$cluster), mean )


