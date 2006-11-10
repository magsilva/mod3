#!/usr/bin/perl 

# Lê um arquivo contendo a saída padrão de um "ls -laR" e gera um arquivo
# contendo os comandos necessários para aplicar este direitos de acesso. Útil
# para quando alguém executa um "chmod -Rf 755 /" e você quer restaurar os
# direitos de acesso originais.
#
# Autores do programa:
# Cesar Fernando Moro (cfmoro@din.uem.br)
# Igor Fabio Steinmacker (ifstein@din.uem.br
# Marco Aurélio Graciotto Silva (magsilva@din.uem.br)

open (MOD,"<teste");
open (MODOUT,">abc");

foreach $linha (<MOD>) {
	$linha =~ s/\n//g;
	if ($linha =~ /^\./) {  
		($dir,$resto)= split (":",$linha);
	} elsif (!($linha =~ /^l/)) {
		($direitos,$ref,$user,$group,$tam,$mes,$dia,$ano,$file,$file2)= split(" ",$linha);
		$userrights=0;
		$grouprights=0;
		$otherrights=0;
		$specialrights=0;
	
		$ruser=substr($direitos,1,1);
		$wuser=substr($direitos,2,1);
		$xuser=substr($direitos,3,1);
		$rgroup=substr($direitos,4,1);
		$wgroup=substr($direitos,5,1);
		$xgroup=substr($direitos,6,1);
		$rother=substr($direitos,7,1);
		$wother=substr($direitos,8,1);
		$xother=substr($direitos,9,1);

		if ($ruser ne '-') { $userrights += 4; }
		if ($wuser ne '-') { $userrights += 2; }
		if ($xuser ne '-') { $userrights += 1; }
		if ($rgroup ne '-') { $grouprights += 4; }
		if ($wgroup ne '-') { $grouprights += 2; }
		if ($xgroup ne '-') { $grouprights += 1; }
		if ($rother ne '-') { $otherrights += 4; }
		if ($wother ne '-') { $otherrights += 2; }
		if ($xother ne '-') { $otherrights += 1; }
	
		if ($xuser eq 's') { $specialrights += 4; }
		if ($xgroup eq 's') { $specialrights += 2; }
		if ($xother eq 't') { $specialrights += 1; }

		if ($file2 eq '') {
			print MODOUT "chmod $specialrights$userrights$grouprights$otherrights $dir/$file \n";
		} else {
			print MODOUT "chmod $specialrights$userrights$grouprights$otherrights $dir/$file2\n";
		}
	}
}
close(MODOUT);
close(MOD);
exit; 
