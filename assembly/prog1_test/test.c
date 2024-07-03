#include <stdio.h>
int main(const int argc, const char **argv){
	printf("test result: ");
	int i = 0;
	while(argv[1][i] != '\0')
	{
		if(argv[1][i] >= 'A' && argv[1][i] <= 'Z')
		{
			printf("%c", argv[1][i] - 'A' + 'a');
		}
		else if(argv[1][i] >= 'a' && argv[1][i] <= 'z')
		{
			printf("%c", argv[1][i]);
		}
		i = i + 1;
	}
	printf("\n");
	return 0;
}
