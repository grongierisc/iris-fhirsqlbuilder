Class User.funcGetEntitiesList Extends %Library.RegisteredObject [ DdlAllowed, Owner = {SuperUser}, Not ProcedureBlock ]
{

ClassMethod GetEntitiesList(tText As %Library.String(MAXLEN=50000)) As %Library.String(MAXLEN=50000) [ Language = python, SqlName = GetEntitiesList, SqlProc ]
{
 
	    import iknowpy 
	    engine = iknowpy.iKnowEngine() 
	    # index some text 
	    text = tText 
	    engine.index(text, 'en') 
	    t_output = "" 
	    # or make it a little nicer 
	    for s in engine.m_index['sentences']: 
	        for e in s['entities']: 
	            if e['type'] == 'Concept': 
	                t_output = t_output  + e['index']+ "|" 
	    return t_output[:-1]
}

}
