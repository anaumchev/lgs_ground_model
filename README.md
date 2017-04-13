# abz2014
The project accompanies the article "A contract-based method to specify stimulus-response requirements".
To verify the examples use the command-line version of AutoProof (http://se.inf.ethz.ch/research/autoproof/manual/#cmd_version) as follows:

$ ec.exe -config abz2014.ecf -target abz2014 -autoproof -autounroll -autoinline GROUND_MODEL && Boogie.exe EIFGENs/abz2014/Proofs/autoproof0.bpl
