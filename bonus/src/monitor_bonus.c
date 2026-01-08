/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   monitor_bonus.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ccavalca <ccavalca@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/01/06 20:19:00 by ccavalca          #+#    #+#             */
/*   Updated: 2026/01/06 20:30:24 by ccavalca         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "philosophers_bonus.h"

int	check_death(t_table *table)
{
	int		i;
	long	now;
	long	elapsed;

	i = 0;
	while (i < table->num_philos)
	{
		now = get_time_ms();
		pthread_mutex_lock(&table->print_mutex);
		elapsed = now - table->philo[i].last_meal;
		pthread_mutex_unlock(&table->print_mutex);
		if (elapsed > table->time_to_die)
		{
			print_death(table, table->philo[i].id);
			return (1);
		}
		i++;
	}
	return (0);
}

static void	print_all_ate(t_table *table)
{
	long	timestamp;

	timestamp = get_elapsed_time_ms(table->start);
	printf("%ld All philosophers have eaten %d times\n",
		timestamp, table->min_meals);
}

int	check_all_ate(t_table *table)
{
	int	i;

	if (table->min_meals == -1)
		return (0);
	pthread_mutex_lock(&table->print_mutex);
	i = 0;
	while (i < table->num_philos)
	{
		if (table->philo[i].meals_eaten < table->min_meals)
		{
			pthread_mutex_unlock(&table->print_mutex);
			return (0);
		}
		i++;
	}
	print_all_ate(table);
	pthread_mutex_unlock(&table->print_mutex);
	return (1);
}

void	*monitor_routine(void *arg)
{
	t_table	*table;

	table = (t_table *)arg;
	while (table->simulation == 1)
	{
		if (check_death(table) || check_all_ate(table))
		{
			table->simulation = 0;
			break ;
		}
		usleep(1000);
	}
	return (NULL);
}
