/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ccavalca <ccavalca@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/12/30 07:30:00 by ccavalca          #+#    #+#             */
/*   Updated: 2026/01/06 20:35:40 by ccavalca         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "philosophers.h"

int validate_args(int ac, char **av)
{
	int i;
	int	result;

	if (ac != 5)
	{
		printf("Error: Invalid arguments\n");
		return (1);
	}
	i = 1;
	while (i < ac)
	{
		if (!av[i] || ft_atoi_safe(av[i], &result) == -1 || result <= 0)
		{
			printf("Error: Invalid argument at position %d\n", i);
			return (1);
		}
		i++;
	}
	return (0);
}

int	parser(int ac, char **av, t_table *table)
{
	if (ac != 5)
		return (1);
	table->num_philos = ft_atoi(av[1]);
	table->time_to_die = ft_atoi(av[2]);
	table->time_to_eat = ft_atoi(av[3]);
	table->time_to_sleep = ft_atoi(av[4]);
	table->start = get_time_ms();
	if (table->time_to_die <= (table->time_to_eat + table->time_to_sleep))
	{
		printf("Error: time_to_die must be > time_to_eat + time_to_sleep\n");
		printf("Recommended: time_to_die >= %ld (at least 100ms margin)\n",
			table->time_to_eat + table->time_to_sleep + 100);
		return (1);
	}
	return (0);
}

static int	init_philo(t_table *table)
{
	int	i;

	i = 0;
	while (i < table->num_philos)
	{
		table->philo[i].id = i + 1;
		table->philo[i].fork_left = &table->forks[i];
		table->philo[i].fork_right = &table->forks[(i + 1) % table->num_philos];
		table->philo[i].last_meal = table->start;
		table->philo[i].table = table;
		i++;
	}
	return (0);
}

int init_table(t_table *table)
{	
	int	i;
	
	table->forks = malloc (sizeof(pthread_mutex_t) * table->num_philos);
	if (!table->forks)
		return (1);
	table->philo = malloc(sizeof(t_philo) * table->num_philos);
	if (!table->philo)
	{
		free(table->forks);
		return (1);
	}
	i = 0;
	while (i < table->num_philos)
	{
		pthread_mutex_init(&table->forks[i], NULL);
		i++;
	}
	pthread_mutex_init(&table->print_mutex, NULL);
	init_philo(table);
	return (0);
}
