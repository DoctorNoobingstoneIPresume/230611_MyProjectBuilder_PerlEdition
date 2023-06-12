use strict; use warnings;
package Konfig;
use Util;

sub CreateObject
{
	my $sClassName = @_ ? shift : Azzert ();
	
	my $self = bless ({}, $sClassName);
	{
		$self->{bShowKonfig} = 0;
		$self->{bExit}       = 0;
		$self->{bAlways}     = 0;
	}
	
	return $self;
}

sub ShowKonfigFlag
{
	my $self = @_ ? shift : Azzert ();
	if (@_) { my $value = shift; $self->{bShowKonfig} = $value; return $self; }
	else    { return $self->{bShowKonfig}; }
}

sub ExitFlag
{
	my $self = @_ ? shift : Azzert ();
	if (@_) { my $value = shift; $self->{bExit      } = $value; return $self; }
	else    { return $self->{bExit      }; }
}

sub AlwaysFlag
{
	my $self = @_ ? shift : Azzert ();
	if (@_) { my $value = shift; $self->{bAlways    } = $value; return $self; }
	else    { return $self->{bAlways    }; }
}

sub ApplyCmdLine
{
	my $self    = @_ ? shift : Azzert ();
	my $rasArgs = @_ ? shift : Azzert ();
	
	my $sPendingOption = '';
	foreach my $sArg (@$rasArgs)
	{
		if (length ($sPendingOption))
		{
			Azzert ();
		}
		else
		{
			if ($sArg =~ m#^\s*[-]+(.*?)\s*$#)
			{
				my $sOption = $1;
				
				if ($sOption eq 'help' || $sOption eq '?')
				{
					printf
					(
						"Usage:\n" .
						"    <program-name> <option>*\n" .
						"\n" .
						"Options:\n" .
						"    --help                 Shows this helpful message.\n" .
						"    -a, --always           Always builds all files.\n" .
						"\n"
					);
					
					$self->ExitFlag (1);
				}
				elsif ($sOption eq 'a' || $sOption eq 'always')
				{
					$self->AlwaysFlag (1);
				}
				elsif ($sOption =~ m#^show-[ck]onfig$#)
				{
					$self->ShowKonfigFlag (1);
				}
				else
				{
					printf ("Unknown option: %s.\n", "\"${sArg}\"");
					return 0;
				}
			}
			else
			{
				printf ("Unexpected normal argument: %s.\n", "\"${sArg}\"");
				return 0;
			}
		}
	}
	
	return 1;
}

sub ToString
{
	my $self = @_ ? shift : Azzert ();
	
	my $sRet = '';
	{
		my $ccTitle = 11;
		$sRet .= sprintf ("%-*s %u\n", $ccTitle, 'bExit'      , $self->{bExit      });
		$sRet .= sprintf ("%-*s %u\n", $ccTitle, 'bShowKonfig', $self->{bShowKonfig});
		$sRet .= sprintf ("%-*s %u\n", $ccTitle, 'bAlways'    , $self->{bAlways    });
	}
	
	return $sRet;
}

1;
