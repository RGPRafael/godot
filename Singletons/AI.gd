extends Node

#Guide used: https://towardsdatascience.com/genetic-algorithm-implementation-in-python-5ab67bb124a6?gi=f8ce632ced77

## chromosome [enemy_type, delay_time]

# [['inimigos'] , ['inimigo1'] , ['inimigo2'], ['inimigo3'], ['inimigo4']]

var Enemy_Type = ['inimigos', 'inimigo1', 'inimigo2', 'inimigo3', 'inimigo4', 'inimigo5']

var Max_time = 3 #
#genes ( Enemy_Type, padding, posistion)
#var population = [['inimigos', 1, Vector2(90,-50)], 
#				  ['inimigo1', 0.9, Vector2(1200,800)], 
#				  ['inimigo2', 0.2, Vector2(1350,-50)], 
#				  ['inimigo3', 1, Vector2(1350,800)], 
#				  ['inimigo4', 0.1, Vector2(-100,100)], 
#				  ['inimigos', 0.1, Vector2(-50,800)] ]

var population = [['inimigos', 1 ], 
				  ['inimigo1', 0.9], 
				  ['inimigo2', 0.2], 
				  ['inimigo3', 1], 
				  ['inimigo4', 0.1], 
				  ['inimigo5', 0.1 ] ]
## receives the results that this generation achieved
## in this example, receives a vector [REACHED_GOAL_BIN, TIME_ALIVE]
var population_res = [[false, 0], [false, 0], [false, 0], [false, 0], [false, 0], [false, 0]]

# organize results of population
var id = -1

# inputs of the equation
var n = population.size()

var num_weights = 2  # Number of the weights we are looking to optimize.

# Is right?
var pop_size = [n,population[0].size()]

# to get random values
var rng = RandomNumberGenerator.new ()

var mutation_prob = 10 #90%

func _ready():
	population_res.resize (pop_size[0])
	
func id ():
	id += 1
	if id >= pop_size[0]:
		id = -1
	return id

# IMPORTANT TO DEFINE THIS FUNCTION FOR EACH GAME
func measure_fitness_SpaceShip(result):
	# FItness dos asteroids = ( 5 x acertou-jogador + 5 x porcentagem-de-vida ) / 10 
	var fit = 0
	var hit = 0
	var percent_hp = 0
	if result[0] == true: #atingiu o player
		hit = 5 
	else: hit = 0
	 
	percent_hp = 5 * result[1]
	
	fit = ( hit + percent_hp )/10
	return fit

#    In this game, we measure the fitness with the time that the enemys survived 
# or if they reached the destination
func measure_fitness_TD (result):
	var fit = 0
	
	if result[0] == true:
		fit = 100
	else:
		fit = -100
		
	fit += result[1] * 100
	return fit


# Calculating the fitness value of each solution in the current population.
# The fitness function calculates the sum of products between each input 
# and its corresponding weight.
func cal_pop_fitness(pop):
	var fitness = []
	
	for i in pop:
		fitness.append(measure_fitness_SpaceShip(i))
		
	return fitness

# Selecting the best individuals in the current generation as parents for produ-
#cing the offspring of the next generation.
func select_mating_pool(pop, fitness, num_parents):
	var parents = []

	for parent_num in range(num_parents):

		var max_fitness_idx = fitness.find (fitness.max())

		parents.append (pop [max_fitness_idx])

		## make this value the smallest one 
		fitness[max_fitness_idx] = -99999999999

	return parents

## Cross over process, will take half of the genes of each parent.
func crossover (parents, offspring_size):
	#parent = [ [gene1, gene2 ], [gene1,gene2 ] ]
	var offspring = []

	# The point at which crossover takes place between two parents. Usually, it is at the center.
	var crossover_point = int (offspring_size[1] / 2 )
 
	for k in range(offspring_size[0]):
		var child = []

		# Index of the first parent to mate.
		var parent1_idx = k % parents.size()

		# Index of the second parent to mate.
		var parent2_idx = (k + 1) % parents.size()

		# The new offspring will have its first half of its genes taken from the first parent.
		for i in range (crossover_point):
			child.append (parents [parent1_idx][i])

		# The new offspring will have its second half of its genes taken from the second parent.
		for i in range (offspring_size[1] - crossover_point ):
			child.append (parents [parent2_idx][i + crossover_point])
			##maybe  remove + 1

		offspring.append (child)

	return offspring

# use the 3 functions below (mutation_int, mutation_float, mutation_string) to
# generate random values for the genes of the individual. You need to adapt for
# your specific program
func mutation_int (idx):
	return 0
	
func mutation_float (idx):
	# the list of genes available
	var gene
	
	# the index of the chromossome that contains a gene of type float.
	if idx == 1:
		gene = Max_time
	
	return rng.randf_range (0, gene)
	
func mutation_string (idx):
	var gene
	if (idx == 0):
		gene = Enemy_Type
		
	var random_index = rng.randi_range (0, gene.size() - 1)
	
	print ('gene: ', gene[random_index])
	
	return gene[random_index]


func random_position():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var n = ControleData.enemy_locations.size()
	return ControleData.enemy_locations[randi() % n]



# In certain situations in nature mutations can occur and will give more
# diversity to the population 
func mutation(offspring_crossover):
	# Mutation changes a single gene in each offspring randomly.
	for idx in range(offspring_crossover.size ()):
		
		# The random value to be added to the gene.

		var random_index = rng.randi_range (0, offspring_crossover[idx].size() - 1)
		
		if offspring_crossover[idx][random_index] is String:
			offspring_crossover[idx][random_index] = mutation_string (random_index)

		elif offspring_crossover[idx][random_index] is int:		
			offspring_crossover[idx][random_index] += mutation_int (random_index)
		
		elif offspring_crossover[idx][random_index] is float:
			offspring_crossover[idx][random_index] += mutation_float (random_index)
			
		else:
			offspring_crossover[idx][random_index] = random_position()

	return offspring_crossover
	
	
func start_experiment ():
	var num_parents_mating = int(population.size() *2/3)
	
	#print ('pop_res....', population_res)
	
	# Measuring the fitness of each chromosome in the population.
	var fitness = cal_pop_fitness(population_res)
	
	# Selecting the best parents in the population for mating.
	var parents = select_mating_pool(population, fitness, num_parents_mating)
	
	#print ('parents....', parents)
	
	# Generating next generation using crossover.
	#  offspring_size[0] = quantidade de filhotes
	#  offspring_size[1] = quantidade de genes
	var offspring_size = [pop_size[0] - parents.size(), pop_size[1]]
	
	var offspring_crossover = crossover (parents, offspring_size)

	# Adding some variations to the offspring using mutation.
	var offspring_mutation = mutation (offspring_crossover)
	
	# Creating the new population based on the parents and offspring.
	var new_population = []

	for i in range (parents.size ()):
		new_population.append (parents[i])

	for i in range (offspring_mutation.size ()):
		new_population.append (offspring_mutation[i])
		
	population = new_population

	return new_population

## class inimigo:
## var speed
## var base_damage , hp = 100.0 , move_direction = 0
## Y = w1x1 + w2x2 + w3x3 + w4x4 + w5x5 + w6x6
## Y =  hp(speed * ' tempo '+ dano)
