/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   time.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ccavalca <ccavalca@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/12/30 07:30:00 by ccavalca          #+#    #+#             */
/*   Updated: 2026/01/06 14:47:53 by ccavalca         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "philosophers.h"

long	get_time_ms(void)
{
	struct timeval	time;
	int				ms_time;
	
	gettimeofday(&time, NULL);
	ms_time = (time.tv_sec * 1000) + (time.tv_usec / 1000);
	return (ms_time);
}

long	get_elapsed_time_ms(long	s_time)
{
	return (get_time_ms() - s_time);
}

int	ft_usleep(long msecs)
{
	long	start;
	long	curr;
	
	start= get_time_ms();
	while (1)
	{
		curr = get_time_ms();
		if ((curr - start) >= msecs)
			break ;
		usleep(100);
	}
	return (0);
}
