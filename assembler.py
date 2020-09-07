import argparse
import os


def main(args):

	assemblyFile = args.file_name
	if '1' in assemblyFile.split('/')[-1]:
		program = '1'
	else:
		program = '2and3'

	with open(assemblyFile) as fread:
		with open(f'/home/jakemdaly/Documents/UCSD/courses/cse141-141l/141L/lab1/basic_processor/MODELSIM/machine_code_p{program}.txt', 'w') as fwrite:

			# Remove empty lines and comments
			fread = [line for line in fread if checkAssembly(line)]

			# Remove labels and save addresses of labels
			i = 0
			dictLabelAddrPairs = {}
			fread_cleaned = []
			for line in fread:
				new_line, i, dictLabelAddrPairs = removeLabels(line, i, dictLabelAddrPairs)
				if new_line:
					fread_cleaned.append(new_line)



			# Next we will loop over lines that need machine code
			for line in fread_cleaned:

				split = line.split()

				# Convert
				try:
					command = commands[split[0]]
				except:
					print()
				if len(split) == 1:
					argument = ''
				else:
					argument = argParse(split[1], dictLabelAddrPairs)

				fwrite.write(command+argument+os.linesep)

	with open(f'/home/jakemdaly/Documents/UCSD/courses/cse141-141l/141L/lab1/basic_processor/MODELSIM/jump_addresses_p{program}.txt', 'w') as fwrite:
		i = 0
		for i in range(len(dictLabelAddrPairs)):
			for key, val in dictLabelAddrPairs.items():
				if val[0]==i:
					addr = "{0:b}".format(val[1])
					while len(addr) < 10:
						addr = '0' + addr

					fwrite.write(addr+os.linesep)


def checkAssembly(line: str) -> bool:
	'''Checks if line (line from a file) will need to be converted to machine code or not. For example, comments and blank lines do not need to be converted'''
	split = line.split()
	if line and len(split) > 0:
		try:
			if '//' not in split[0]:
				return(True)
		except:
			print()
	return(False)

def removeLabels(line: str, instROMAddr: int, dictLabelAddrPairs: dict) -> str:
	'''Will remove a line that's a label and store it's address in dictLabelAddrPairs'''
	split = line.split()
	if (len(split) == 1 and split[0].endswith(':')):
		dictLabelAddrPairs.update({split[0]: [len(dictLabelAddrPairs), instROMAddr]})
		return([], instROMAddr, dictLabelAddrPairs)
	else:
		instROMAddr += 1
		return(line, instROMAddr, dictLabelAddrPairs)


def argParse(arg: str, dictLabelAddrPairs: dict) -> str:

	argStr = list(arg)
	binDigits = ''

	# First check for register reference
	if argStr[0]=='R' and argStr[1].isdigit():
		binDigits = "{0:b}".format(int(binDigits.join(argStr[1:])))
		while (len(binDigits) < 4):
			binDigits = '0' + binDigits

	# Next check for string constants
	if argStr[0].isdigit():
		numDigits = int(argStr[0])
		try:
			binDigits = "{0:b}".format(int(binDigits.join(argStr[3:])))
		except:
			print()
		while (len(binDigits) < numDigits):
			binDigits = '0' + binDigits

	# Finally check and handle a jump address
	if arg.isalpha():
		try:
			binDigits = "{0:b}".format(dictLabelAddrPairs[arg+':'][0])
		except:
			print()
		while (len(binDigits) < 4):
			binDigits = '0' + binDigits

	return(binDigits)

commands = {
	'LDR': '00000',
	'LDM': '00001',
	'STR': '00010',
	'STM': '00011',
	'ACM': '00100',
	'SUB': '00101',
	'ADD': '00110',
	'AND': '00111',
	'XOR': '01000',
	'RXR': '01001',
	'LSL': '01010',
	'CMP': '01011',
	'BEQ': '01100',
	'BNE': '01101',
	'CLR': '011100000',
	'DUN': '011110000',
	'LDA': '10',
	'STA': '11'
}

if __name__ == '__main__':

	parser = argparse.ArgumentParser(description='Assembler for the RISC accumulator encryption/decryption programs.')
	parser.add_argument('file_name', type=str, help='Assembly file to be converted to machine code.')

	args = parser.parse_args()

	main(args)