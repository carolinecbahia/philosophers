/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   validation.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ccavalca <ccavalca@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/01/14 00:00:00 by ccavalca          #+#    #+#             */
/*   Updated: 2026/01/14 00:00:00 by ccavalca         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "philosophers.h"

static int	validate_arg_count(int ac)
{
	if (ac != 5 && ac != 6)
	{
		printf("Error: Invalid number of arguments\n");
		printf("Usage: ./philo <num> <die> <eat> <sleep> [must_eat]\n");
		return (1);
	}
	return (0);
}

static int	validate_single_arg(char *arg, int pos)
{
	int	j;

	if (!arg || arg[0] == '\0')
	{
		printf("Error: Invalid argument at position %d\n", pos);
		return (1);
	}
	j = 0;
	while (arg[j])
	{
		if (arg[j] < '0' || arg[j] > '9')
		{
			printf("Error: Invalid argument at position %d\n", pos);
			return (1);
		}
		j++;
	}
	if (ft_atoi(arg) <= 0)
	{
		printf("Error: Invalid argument at position %d\n", pos);
		return (1);
	}
	return (0);
}

int	validate_args(int ac, char **av)
{
	int	i;

	if (validate_arg_count(ac) != 0)
		return (1);
	i = 1;
	while (i < ac)
	{
		if (validate_single_arg(av[i], i) != 0)
			return (1);
		i++;
	}
	return (0);
}
