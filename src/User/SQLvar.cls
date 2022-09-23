Class User.SQLvar
{

Query AllEntity() As %Query(CONTAINID = 1, ROWSPEC = "Key:%String,DescriptionText:%String,LifecycleStatus:%String,SubjectReference:%String,Entity:%String") [ SqlName = AllEntity, SqlProc ]
{
}

ClassMethod AllEntityExecute(ByRef qHandle As %Binary) As %Status
{
    Kill ^||%ISC.ZRS

    set tSQL = "SELECT ID, DescriptionText, Key, LifecycleStatus, SubjectReference  FROM AA.Goal"
    set tRs = ##class(%SQL.Statement).%ExecDirect(,tSQL)
    While (tRs.%Next()) {
        set tID = tRs.ID
        set tKey = tRs.Key
        set tDescriptionText = tRs.DescriptionText
        set tLifecycleStatus = tRs.LifecycleStatus
        set tSubjectReference = tRs.SubjectReference
        set tEntity = "AA.Goal"
        set ^||%ISC.ZRS(tID) = $LB(tKey,tDescriptionText,tLifecycleStatus,tSubjectReference)
        set tEntities = ##class(User.SQLvar).IKnowParser(tDescriptionText)
        Set N=tEntities.%Size()
        For i=0:1:N-1 {
            set ^||%ISC.ZRS(tID,i) = tEntities.%Get(i)
        }
    }

    set qHandle = $lb("","")

    Quit $$$OK
}

ClassMethod AllEntityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AllEntityExecute ]
{
    set index = $List(qHandle,1)
    set sub = $List(qHandle,2)

    Set:(sub="") index = $O(^||%ISC.ZRS(index))
    set sub = $O(^||%ISC.ZRS(index,sub))
    if sub = "" {
        set index = $O(^||%ISC.ZRS(index))
        If index="" {
            Set Row = ""
            Set AtEnd = 1
            return $$$OK
        }
        set sub = $O(^||%ISC.ZRS(index,sub))
    }


    Set Row = $Lb($List(^||%ISC.ZRS(index),1), $List(^||%ISC.ZRS(index),2), $List(^||%ISC.ZRS(index),3), $List(^||%ISC.ZRS(index),4),^||%ISC.ZRS(index,sub))
    set qHandle = $Lb(index,sub)

    Quit $$$OK
}

ClassMethod IKnowParser(tText As %String) As %String [ Language = python ]
{
import iknowpy
import iris

engine = iknowpy.iKnowEngine()

# index some text
text = tText
engine.index(text, 'en')

tDyna = iris.cls('%DynamicArray')._New()

# or make it a little nicer
for s in engine.m_index['sentences']:
    for e in s['entities']:
        if e['type'] == 'Concept':
            tDyna._Push(e['index'])

return tDyna
}

ClassMethod IKnowParserText(tText As %String) As %String [ Language = python ]
{
import iknowpy

engine = iknowpy.iKnowEngine()

# index some text
text = tText
engine.index(text, 'en')

tDyna = ""

# or make it a little nicer
for s in engine.m_index['sentences']:
    for e in s['entities']:
        if e['type'] == 'Concept':
            tDyna = tDyna  + e['index']+ "|"

return tDyna[:-1]
}

ClassMethod GetEntitiesList(pText) As %List [ SqlName = GetEntitiesList, SqlProc ]
{
 

    Return ##class(User.SQLvar).IKnowParserText(pText)
}

ClassMethod AllEntityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AllEntityFetch ]
{
    Set qHandle = ""
    Kill ^||%ISC.ZRS
    Quit $$$OK
}

ClassMethod GetJSON(json As %String, name As %String) As %String(MAXLEN="") [ SqlName = GetJSON, SqlProc ]
{

    quit:(json="") ""

    set dyna = {}.%FromJSON(json)

    set result = dyna.%Get(name)

    quit $s(result'="":$s(($classname(result)="%Library.DynamicObject")||($classname(result)="%Library.DynamicArray"):result.%ToJSON(),1:{}.%Set(name,result,dyna.%GetTypeOf(name)).%ToJSON()),1:"")
}

ClassMethod GetProp(json As %String, prop As %String) As %String(MAXLEN="") [ SqlName = GetProp, SqlProc ]
{
    quit:(json="") ""

    set dyna = {}.%FromJSON(json)

    Quit dyna.%Get(prop)
}

ClassMethod GetAtJSON(json As %String, position As %Integer) As %String(MAXLEN="") [ SqlName = GetAtJSON, SqlProc ]
{
    quit:(json="") ""

    set dyna = [].%FromJSON(json)
    
    set i = 0
    set iterator = dyna.%GetIterator()
    
    while iterator.%GetNext(.key, .result) {
        quit:(i=position) 
        do $Increment(i)
    }

    Quit $s(result'="":$s(($classname(result)="%Library.DynamicObject")||($classname(result)="%Library.DynamicArray"):result.%ToJSON(),1:{}.%Set(key,result,dyna.%GetTypeOf(key)).%ToJSON()),1:"")
}

}
