CREATE FUNCTION sqliknowparser(tText VARCHAR(50000))
    RETURNS VARCHAR(50000)
    LANGUAGE PYTHON
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