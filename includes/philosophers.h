/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   philosophers.h                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ccavalca <ccavalca@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/12/20 00:13:21 by ccavalca          #+#    #+#             */
/*   Updated: 2025/12/20 00:13:22 by ccavalca         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */


#ifndef [PROJECT_NAME_UPPERCASE]_H_
#define [PROJECT_NAME_UPPERCASE]_H_

/* ============================================================================
** INCLUDES
** ============================================================================ */

#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <stddef.h>

/* ============================================================================
** DEFINES & CONSTANTS
** ============================================================================ */

#define SUCCESS 0
#define FAILURE -1
#define TRUE 1
#define FALSE 0

/* ============================================================================
** STRUCTURES
** ============================================================================ */

/**
 * struct s_data - Description of your structure
 * @member1: What member1 does
 * @member2: What member2 does
 *
 * This structure is used for [purpose].
 */
typedef struct s_data
{
	int		member1;
	char	*member2;
}	t_data;

/* ============================================================================
** FUNCTION PROTOTYPES
** ============================================================================ */

/* Initialization functions */
t_data	*init_data(void);
void	free_data(t_data *data);

/* Core functions */
int		process_data(t_data *data);
int		validate_input(const char *input);

/* Utility functions */
char	*my_function(const char *param1, int param2);

#endif /* ![PROJECT_NAME_UPPERCASE]_H_ */
