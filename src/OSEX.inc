ROUTINE OSEX [Type=INC]
#define TRUE  1
#define FALSE 0

#define CHECK(%statement) set ##unique(new) = %statement if ($$$ISERR(##unique(old))) { return ##unique(old) }