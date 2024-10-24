nsduh_import = function(html, number, name) {
  
  drug_table =
    html |> 
    html_table() |> 
    nth(number) |> 
    slice(-1) |> 
    mutate(drug = "name") |> 
    select(-contains("P Value"))
  
  return(drug_table)
  
} 

bind_rows(
  nsduh_import(html = nsduh_html, 1, "marj"),
  nsduh_import(html = nsduh_html, 4, "cocaine"),
  nsduh_import(html = nsduh_html, 5, "heroine"))