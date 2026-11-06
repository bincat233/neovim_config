; extends

([(identifier) (type_identifier)] @keyword.storage
  (#any-of? @keyword.storage
    "__data" "__near" "__idata" "__xdata" "__far" "__pdata" "__code"
    "__bit" "__sfr" "__sfr16" "__sfr32" "__sbit"))

((identifier) @attribute
  (#any-of? @attribute
    "__at" "__using" "__interrupt" "__critical" "__reentrant"
    "__banked" "__nonbanked" "__naked"))
