# Stant - Backend

## Rotas

- GET "/talks": listagem de palestras
- POST "/talks": criacao de palestra
- GET "/talks/{id}": visualizacao de palestra
- PUT "/talks/{id}": edicao de palestra
- DELETE "/talks/{id}": exclusao de palestra
- DELETE "/talks": exclusao de todas as palestras
- POST "/upload-file": upload de arquivo de palestras
- GET "/schedule": criacao de cronograma das palestras

## Subir servidor localmente

```
rails s
```