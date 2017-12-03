/*
 * MAX1163.h
 *
 *  Created on: Dec 3, 2017
 *      Author: root
 */

#ifndef MAX1163_H_
#define MAX1163_H_
#include <xil_types.h>

typedef struct
{
	void (* initialize) (void);
	u16  (* read)       (u8 channel);
} MAX1163;

MAX1163 * MAX1163_instance(void);

#endif /* MAX1163_H_ */
