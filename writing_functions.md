Iteration
================
Mahdi Maktabi
2024-10-24

What is a function?

- A function takes inputs, does something, and returns a result
- For computations or operations you define and need to repeat, write a
  function for arbitrary inputs to produce the corresponding outputs.

## Writing my first function

As an example, here is a z-score computation

``` r
x_vec = rnorm(n = 25, mean = 10, sd = 3.5)

(x_vec - mean(x_vec)) / sd(x_vec)
```

Now I’ll write a function to do this.

``` r
z_scores = function(x) {
  
  if (!is.numeric(x)) {
    stop("Argument x should be numeric")
  } else if (length(x) == 1) {
    stop("Z scores cannot be computed for length 1 vectors")
  }
  
  z = mean(x) / sd(x)
  
  z
}
```

Does this always work?

``` r
z_scores(x=3)
z_scores(x = c("my", "name", "is", "mahdi"))

z_scores(x = x_vec)
```

## A new function

``` r
mean_and_sd = function(x) {
  
  mean_x = mean(x)
  sd_x = sd(x)
  
  out_df =
    tibble(
      mean = mean_x,
      sd = sd_x
    )
  
  return(out_df)
  
}

mean_and_sd(x_vec)
```

    ## Error: object 'x_vec' not found

## Check stuff using a simulation

``` r
sim_df =
  tibble(
    x = rnorm(30, 10, 5)
  )

sim_df |> 
  summarize(
    mean = mean(x),
    sd = sd(x)
  )
```

    ## # A tibble: 1 × 2
    ##    mean    sd
    ##   <dbl> <dbl>
    ## 1  9.81  4.80

Simulation function to check sample mean and sd.

``` r
sim_mean_sd = function(samp_size, true_mean, true_sd) {
  
  sim_df =
  tibble(
    x = rnorm(samp_size, true_mean, true_sd)
  )

  out_df = 
    sim_df |> 
    summarize(
      mean = mean(x),
      sd = sd(x)
  )
  
  return(out_df)
  
}

sim_mean_sd(samp_size = 30, true_mean = 4, true_sd = 12)
```

    ## # A tibble: 1 × 2
    ##    mean    sd
    ##   <dbl> <dbl>
    ## 1  3.57  12.9

``` r
sim_mean_sd(true_mean = 4, true_sd = 12, samp_size = 30)
```

    ## # A tibble: 1 × 2
    ##    mean    sd
    ##   <dbl> <dbl>
    ## 1  6.61  11.7

## Revisit LoTR movies dataset

``` r
fellowship_df = 
  read_excel("data/LotR_Words.xlsx", range = "B3:D6") |> 
  mutate(movie = "fellowship") |> 
  janitor::clean_names()

two_towers_df = 
  read_excel("data/LotR_Words.xlsx", range = "F3:H6") |> 
  mutate(movie = "two_towers_df") |> 
  janitor::clean_names()

return_king_df = 
  read_excel("data/LotR_Words.xlsx", range = "J3:L6") |> 
  mutate(movie = "return_king_df") |> 
  janitor::clean_names()
```

Doing this with a function instead

``` r
lotr_import = function(cell_range, movie_title) {
  
  movie_df = 
    read_excel("data/LotR_Words.xlsx", range = cell_range) |> 
    mutate(movie = movie_title) |> 
    janitor::clean_names() |> 
    pivot_longer(
      female:male,
      names_to = "sex",
      values_to = "words") |> 
    select(movie, everything())
  
  return(movie_df)
  
}

lotr_df = 
  bind_rows(
    lotr_import(cell_range = "B3:D6", movie_title = "fellowship"),
    lotr_import(cell_range = "F3:H6", movie_title = "two_towers"),
    lotr_import("J3:L6", "return_king"))
```
