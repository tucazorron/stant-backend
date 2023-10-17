# Stant - Backend

## API em producao

```
https://stant-backend-7998ec046276.herokuapp.com
```

## Subir servidor localmente

```
rails s
```

## Rotas

- GET "/talks": listagem de palestras
- POST "/talks": criacao de palestra
- GET "/talks/{id}": visualizacao de palestra
- PUT "/talks/{id}": edicao de palestra
- DELETE "/talks/{id}": exclusao de palestra
- DELETE "/talks": exclusao de todas as palestras
- POST "/upload-file": upload de arquivo de palestras
- GET "/schedule": criacao de cronograma das palestras

## Alteracoes

- Alterei o modelo de gerar cronograma de palestras para um modelo mais otimizado, ordenanda as palestras por tempo descendente e sempre alocando primeiro as palestras de maior duracao. Assim, os intervalos ficam mais preenchidos e podemos ter menos tracks ao final do dia