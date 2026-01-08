/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   routines_bonus.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ccavalca <ccavalca@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/01/06 20:18:42 by ccavalca          #+#    #+#             */
/*   Updated: 2026/01/06 20:28:26 by ccavalca         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "philosophers_bonus.h"

void	philo_eat(t_philo *philo, t_table *table)
{
	pthread_mutex_lock(&table->print_mutex);
	philo->last_meal = get_time_ms();
	philo->meals_eaten++;
	pthread_mutex_unlock(&table->print_mutex);
	print_status(table, philo->id, "is eating");
	ft_usleep(table->time_to_eat);
}

void	philo_sleep(t_table *table, int philo_id)
{
	print_status(table, philo_id, "is sleeping");
	ft_usleep(table->time_to_sleep);
}

void	philo_think(t_table *table, int philo_id)
{
	print_status(table, philo_id, "is thinking");
}