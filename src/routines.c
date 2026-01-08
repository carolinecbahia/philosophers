/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   routines.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ccavalca <ccavalca@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/01/06 17:16:13 by ccavalca          #+#    #+#             */
/*   Updated: 2026/01/06 19:54:44 by ccavalca         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */


#include "philosophers.h"

void	philo_eat(t_philo *philo, t_table *table)
{
	pthread_mutex_lock(&table->print_mutex);
	philo->last_meal = get_time_ms();
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
