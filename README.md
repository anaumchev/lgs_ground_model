# Landing Gear System ground model specification and requirements in Eiffel

The project accompanies the article "Towards a general method for expressing and proving embedded software requirements".

To verify the examples use the command-line version of AutoProof (http://se.inf.ethz.ch/research/autoproof/manual/#cmd_version) as follows:

$ ec.exe -config lgs_ground_model.ecf -target lgs_ground_model -autoproof -autounroll -autoinline GROUND_MODEL && Boogie.exe EIFGENs/lgs_ground_model/Proofs/autoproof0.bpl

To verify a single requirement, say 'extension_duration', use the following format instead:

$ ec.exe -config lgs_ground_model.ecf -target lgs_ground_model -autoproof -autounroll -autoinline GROUND_MODEL.extension_duration && Boogie.exe EIFGENs/lgs_ground_model/Proofs/autoproof0.bpl

Before that replace the standard base_theory.bpl file inside of the Eve distribution with the one from this repository.
