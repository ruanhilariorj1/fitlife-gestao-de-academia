from django.urls import path
from . import views

urlpatterns = [
    path('alunos/', views.listar_alunos, name='listar_alunos'),
    path('alunos/cadastro/', views.cadastrar_aluno, name='cadastrar_aluno'),
    path('alunos/<str:cpf>/editar/', views.editar_aluno, name='editar_aluno'),
    path('alunos/<str:cpf>/', views.detalhe_aluno, name='detalhe_aluno'),
    path('alunos/<str:cpf>/excluir/', views.excluir_aluno, name='excluir_aluno'),
]
