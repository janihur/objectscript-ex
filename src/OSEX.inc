ROUTINE OSEX [Type=INC]
#define TRUE  1
#define FALSE 0

#define ASSERT(%statement) if ('(%statement)) { throw ##class(%Exception.General).Create("Assertion failed. Stack: "_$stack($stack,"PLACE")) }

#define ASSERTSTATUS(%statement) set ##unique(new) = %statement if ($$$ISERR(##unique(old))) { throw ##class(%Exception.StatusException).CreateFromStatus(##unique(old)) }

#define CHECK(%statement) set ##unique(new) = %statement if ($$$ISERR(##unique(old))) { return ##unique(old) }