/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

#include <stdio.h>
#include <xil_printf.h>
#include "platform.h"
#include <xil_types.h>
#include "ADC/MAX1163.h"

#define ADC_SAMPLES 1000 // Define the number of samples to take

int main()
{
	int channel;
    init_platform();

    MAX1163 * adc = MAX1163_instance();  // ADC driver

    adc->initialize();

    xil_printf("\n\r___ MAX1163 driver test ___\n\r");

    for (;;)
    {
    	xil_printf("\n\rADC Channel:\n\r");
		channel = inbyte() - '0';

		if (0 <= channel && channel <= 9) // Check the range of channel
		{
			int sample;
			u32 adc_value;

			for (sample = 0; sample < ADC_SAMPLES; sample ++)
			{
				adc_value = adc->read(channel); // Read ADC channel

				xil_printf("ADC channel %d [%d] = 0x%X\n\r", channel, sample, adc_value);
			}
		}
		else
		{
			xil_printf("Invalid channel\n\r");
		}
    }

    cleanup_platform();
    return 0;
}
