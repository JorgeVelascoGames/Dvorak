
1-Primero, decidimos cuantos enemigos y mejoras deben aparecer en el mapa-
2-Tenemos una lista hardcodeada de todas las salas del nivel. Cada sala tiene un punto de spawn
3-Tenemos varias escenas con salas distintas 
4-Se genera una sala en cada habitación
5-Las salas deberán configurarse con varios puntos de drop para items, los cuales estarán registrados en un array.
6-Las salas incluyen a los enemigos ya spawneados
7-También un punto de spawn para un atril
8-Se hace una randomización de la lista de salas
9-Luego se hace un loop por las mismas, spawneando los objetos y los atriles. Esto asegura que haya una distribución relativamente uniforme, sin que queden amplias áreas vacías.
10- Todas las salas tienen una cruz, se destruyen todas menos una (variable según mejoras)


El otro nodo de randomización podrá ser utilizado en otros proyectos. Tiene un array donde se incluyen:

El spawner: Spawnea una escena en su posición. Tiene un array, y elegirá un item al azar de su lista. Se puede añadir una posibilidad de no spawnear nada. Se puede añadir un nodo al que hacer hijo, en cuyo caso el spawneador se destruirá. De lo contrario, mantendrá al la escena instanciada como hija suya.

El selector: Destruirá items al azar de su lista. Dejará sin destruir tantos items como se le ordene.

El despawneador: Tiene una posibilidad marcada de destruir un item.