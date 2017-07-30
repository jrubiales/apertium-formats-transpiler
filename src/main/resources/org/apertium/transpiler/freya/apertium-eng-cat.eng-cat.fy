transfer(default="chunk")
    
	catlex det = "det.dem.*";
	
	attribute a_nom = "n", "n.acr", "np.loc", "np.ant", "np.cog", "np.al", "adv";
	attribute a_det = "det.def";
	attribute gen_sense_mf = "m", "f", "GD", "nt";
	attribute gen_mf = "mf";
	attribute nbr_sense_sp = "sg", "pl", "ND";
	attribute nbr_sp = "sp";
	
	var negative;
	var nbr_chunk;
	var gen_chunk;
	var tipus_det;
	
	macro det_no(npar=2)
		choose
			when (clip(pos=2, side="sl", part=nbr) == litTag("pl")) and (clip(pos=1, side="sl", part="lem") === "no") then
				clip(pos=2, side="tl", part=nbr) = litTag("sg");
				negative = litTag("negacio");
			end /* when */
			when (clip(pos=2, side="sl", part=nbr) == litTag("sg")) and (clip(pos=1, side="sl", part="lem") === "no") then
				negative = litTag("negacio");
			end /* when */
			otherwise 
				negative = "";
			end /* otherwise */
		end /* choose */
	end /* macro */
	
	rule(comment="REGLA: DET NOM")
		pattern = det, nom;
		det_no(1, 2);
		f_concord2(2, 1);
		firstWord(1);
		determiner(1);
		out
			chunk det_nom (case="caseFirstWord")
				tags
                                    litTag("SN");
                                    tipus_det;
                                    gen_chunk;
                                    nbr_chunk;
                                    negative;
				end /* tags */
				lu
                                    clip(pos=1, side="tl", part="lem");
                                    clip(pos=1, side="tl", part=a_det);
                                    clip(pos=1, side="tl", part=gen_sense_mf, link-to="3");
                                    clip(pos=1, side="tl", part=gen_mf);
                                    clip(pos=1, side="tl", part=nbr_sense_sp, link-to="4");
                                    clip(pos=1, side="tl", part=nbr_sp);
				end /* lu */
				b(1);
				lu
                                    clip(pos=2, side="tl", part="lemh");
                                    clip(pos=2, side="tl", part=a_nom);
                                    clip(pos=2, side="tl", part=gen_sense_mf, link-to="3");
                                    clip(pos=2, side="tl", part=gen_mf);
                                    clip(pos=2, side="tl", part=nbr_sense_sp, link-to="4");
                                    clip(pos=2, side="tl", part=nbr_sp);
                                    clip(pos=2, side="tl", part="lemq");
				end /* lu */
			end /* chunk */
		end /* out */
	end /* rule */

end /* transfer */