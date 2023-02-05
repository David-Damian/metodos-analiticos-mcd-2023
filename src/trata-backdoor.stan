data {
  int<lower=0> N;
  vector[N] trata;
  array[N] int res;
  vector[N] peso;

}

transformed data {
  real media_peso;

  // centrar
  media_peso = mean(peso);
}

parameters {
  real gamma_0;
  real gamma_1;
  real gamma_2;
}

transformed parameters {
  vector[N] p_logit_res;

  p_logit_res = gamma_0 + gamma_1 * trata + gamma_2 * (peso - media_peso);

}

model {
  // modelo de resultado
  res ~ bernoulli_logit(p_logit_res);
  gamma_0 ~ normal(0, 2);
  gamma_1 ~ normal(0, 1);
  gamma_2 ~ normal(0, 0.2);


}
generated quantities {
  real dif_trata;
  real p_trata;
  real p_no_trata;

  real peso_sim = 70;
  p_trata = inv_logit(gamma_0 + gamma_1 * 1 + gamma_2 * (peso_sim - media_peso));
  p_no_trata = inv_logit(gamma_0 + gamma_1 * 0 + gamma_2 * (peso_sim - media_peso));
  dif_trata = p_trata - p_no_trata;
}