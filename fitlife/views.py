from django.shortcuts import render, redirect, get_object_or_404
from .models import Aluno, Plano, ContratoPlan, Pagamento, Fatura, Modalidade, Turma, Inscricao, Unidade, Professor
from django.contrib.auth.decorators import login_required
from django.contrib.auth.decorators import permission_required
from django.contrib import messages

# =============================================================================
# ALUNOS
# =============================================================================

@login_required
@permission_required('fitlife.view_aluno', raise_exception=True)
def listar_alunos(request):
    alunos = Aluno.objects.all()

    busca = request.GET.get('busca')
    ordem = request.GET.get('ordem')

    if busca:
        alunos = alunos.filter(nome_aluno__icontains=busca)

    if ordem == 'nome_za':
        alunos = alunos.order_by('-nome_aluno')
    elif ordem == 'nascimento':
        alunos = alunos.order_by('data_nascimento')
    else:
        alunos = alunos.order_by('nome_aluno')

    return render(
        request,
        'fitlife/listar_alunos.html',
        {
            'alunos': alunos,
            'busca': busca,
            'ordem': ordem,
        }
    )


@login_required
@permission_required('fitlife.add_aluno', raise_exception=True)
def cadastrar_aluno(request):
    if request.method == 'POST':
        cpf             = request.POST.get('cpf')
        nome_aluno      = request.POST.get('nome_aluno')
        data_nascimento = request.POST.get('data_nascimento')
        endereco_aluno  = request.POST.get('endereco_aluno')
        telefone_aluno  = request.POST.get('telefone_aluno')
        e_mail          = request.POST.get('e_mail')
        restricoes      = request.POST.get('restricoes')

        Aluno.objects.create(
            cpf            = cpf,
            nome_aluno     = nome_aluno,
            data_nascimento= data_nascimento,
            endereco_aluno = endereco_aluno,
            telefone_aluno = telefone_aluno,
            e_mail         = e_mail,
            restricoes     = restricoes
        )
        messages.success(request, 'Aluno cadastrado com sucesso!')
        return redirect('listar_alunos')

    return render(request, 'fitlife/cadastrar_aluno.html')


@login_required
@permission_required('fitlife.change_aluno', raise_exception=True)
def editar_aluno(request, cpf):
    aluno = get_object_or_404(Aluno, cpf=cpf)

    if request.method == 'POST':
        aluno.nome_aluno      = request.POST.get('nome_aluno')
        aluno.data_nascimento = request.POST.get('data_nascimento')
        aluno.endereco_aluno  = request.POST.get('endereco_aluno')
        aluno.telefone_aluno  = request.POST.get('telefone_aluno')
        aluno.e_mail          = request.POST.get('e_mail')
        aluno.restricoes      = request.POST.get('restricoes')
        aluno.save()
        messages.success(request, 'Aluno atualizado com sucesso!')
        return redirect('listar_alunos')

    return render(
        request,
        'fitlife/editar_aluno.html',
        {'aluno': aluno}
    )


@login_required
@permission_required('fitlife.view_aluno', raise_exception=True)
def detalhe_aluno(request, cpf):
    aluno = get_object_or_404(Aluno, cpf=cpf)

    return render(
        request,
        'fitlife/detalhe_aluno.html',
        {'aluno': aluno}
    )


@login_required
@permission_required('fitlife.delete_aluno', raise_exception=True)
def excluir_aluno(request, cpf):
    aluno = get_object_or_404(Aluno, cpf=cpf)

    if request.method == 'POST':
        aluno.delete()
        messages.success(request, 'Aluno excluído com sucesso!')
        return redirect('listar_alunos')

    return render(
        request,
        'fitlife/confirmar_exclusao.html',
        {'aluno': aluno}
    )

# =============================================================================
# PAGAMENTOS
# =============================================================================

@login_required
@permission_required('fitlife.view_pagamento', raise_exception=True)
def listar_pagamentos(request):
    pagamentos = Pagamento.objects.all()

    busca  = request.GET.get('busca')
    status = request.GET.get('status')
    ordem  = request.GET.get('ordem')

    if busca:
        pagamentos = pagamentos.filter(num_contrato__cpf_aluno__nome_aluno__icontains=busca)

    if status:
        pagamentos = pagamentos.filter(status_pag=status)

    if ordem == 'valor_desc':
        pagamentos = pagamentos.order_by('-valor')
    elif ordem == 'valor_asc':
        pagamentos = pagamentos.order_by('valor')
    elif ordem == 'vencimento_desc':
        pagamentos = pagamentos.order_by('-vencimento')
    else:
        pagamentos = pagamentos.order_by('vencimento')

    return render(
        request,
        'fitlife/listar_pagamentos.html',
        {
            'pagamentos': pagamentos,
            'busca':      busca,
            'status':     status,
            'ordem':      ordem,
        }
    )

@login_required
@permission_required('fitlife.add_pagamento', raise_exception=True)
def criar_pagamento(request):
    if request.method == 'POST':
        num_contrato    = request.POST.get('num_contrato')
        forma_pagamento = request.POST.get('forma_pagamento')
        valor           = request.POST.get('valor')
        vencimento      = request.POST.get('vencimento')
        status_pag      = request.POST.get('status_pag')

        Pagamento.objects.create(
            num_contrato    = ContratoPlan.objects.get(pk=num_contrato),
            forma_pagamento = forma_pagamento,
            valor           = valor,
            vencimento      = vencimento,
            status_pag      = status_pag
        )
        messages.success(request, 'Pagamento registrado com sucesso!')
        return redirect('listar_pagamentos')

    contratos = ContratoPlan.objects.all()
    return render(request, 'fitlife/criar_pagamento.html', {'contratos': contratos})

@login_required
@permission_required('fitlife.change_pagamento', raise_exception=True)
def editar_pagamento(request, cod_pagamento):
    pagamento = get_object_or_404(Pagamento, cod_pagamento=cod_pagamento)

    if request.method == 'POST':
        pagamento.forma_pagamento = request.POST.get('forma_pagamento')
        pagamento.valor           = request.POST.get('valor')
        pagamento.vencimento      = request.POST.get('vencimento')
        pagamento.status_pag      = request.POST.get('status_pag')
        pagamento.save()
        messages.success(request, 'Pagamento atualizado com sucesso!')
        return redirect('listar_pagamentos')

    return render(
        request,
        'fitlife/editar_pagamento.html',
        {'pagamento': pagamento}
    )
    
@login_required
@permission_required('fitlife.view_pagamento', raise_exception=True)
def detalhe_pagamento(request, cod_pagamento):
    pagamento = get_object_or_404(Pagamento, cod_pagamento=cod_pagamento)

    return render(
        request,
        'fitlife/detalhe_pagamento.html',
        {'pagamento': pagamento}
    )

# =============================================================================
# TURMAS
# =============================================================================

@login_required
@permission_required('fitlife.view_turma', raise_exception=True)
def listar_turmas(request):
    turmas = Turma.objects.all()

    busca = request.GET.get('busca')
    ordem = request.GET.get('ordem')

    if busca:
        turmas = turmas.filter(cod_modalidade__nome_mod__icontains=busca)

    if ordem == 'capacidade_desc':
        turmas = turmas.order_by('-capacidade')
    elif ordem == 'capacidade_asc':
        turmas = turmas.order_by('capacidade')
    else:
        turmas = turmas.order_by('cod_turma')

    return render(
        request,
        'fitlife/listar_turmas.html',
        {
            'turmas': turmas,
            'busca':  busca,
            'ordem':  ordem,
        }
    )


@login_required
@permission_required('fitlife.add_turma', raise_exception=True)
def criar_turma(request):
    if request.method == 'POST':
        Turma.objects.create(
            cod_modalidade = Modalidade.objects.get(pk=request.POST.get('cod_modalidade')),
            cod_unidade    = Unidade.objects.get(pk=request.POST.get('cod_unidade')),
            cref_professor = Professor.objects.get(pk=request.POST.get('cref_professor')),
            capacidade     = request.POST.get('capacidade'),
        )
        messages.success(request, 'Turma criada com sucesso!')
        return redirect('listar_turmas')

    return render(request, 'fitlife/criar_turma.html', {
        'modalidades': Modalidade.objects.all(),
        'unidades':    Unidade.objects.all(),
        'professores': Professor.objects.all(),
    })

@login_required
@permission_required('fitlife.change_turma', raise_exception=True)
def editar_turma(request, cod_turma):
    turma = get_object_or_404(Turma, cod_turma=cod_turma)

    if request.method == 'POST':
        turma.cod_modalidade = Modalidade.objects.get(pk=request.POST.get('cod_modalidade'))
        turma.cod_unidade    = Unidade.objects.get(pk=request.POST.get('cod_unidade'))
        turma.cref_professor = Professor.objects.get(pk=request.POST.get('cref_professor'))
        turma.capacidade     = request.POST.get('capacidade')
        turma.save()
        messages.success(request, 'Turma atualizada com sucesso!')
        return redirect('listar_turmas')

    return render(
        request,
        'fitlife/editar_turma.html',
        {
            'turma':       turma,
            'modalidades': Modalidade.objects.all(),
            'unidades':    Unidade.objects.all(),
            'professores': Professor.objects.all(),
        }
    )
    
@login_required
@permission_required('fitlife.view_turma', raise_exception=True)
def detalhe_turma(request, cod_turma):
    turma     = get_object_or_404(Turma, cod_turma=cod_turma)
    inscricoes = turma.inscricoes.select_related('cpf_aluno')

    return render(
        request,
        'fitlife/detalhe_turma.html',
        {
            'turma':      turma,
            'inscricoes': inscricoes,
        }
    )

@login_required
@permission_required('fitlife.delete_turma', raise_exception=True)
def excluir_turma(request, cod_turma):
    turma = get_object_or_404(Turma, cod_turma=cod_turma)

    if request.method == 'POST':
        turma.delete()
        messages.success(request, 'Turma excluída com sucesso!')
        return redirect('listar_turmas')

    return render(
        request,
        'fitlife/confirmar_exclusao_turma.html',
        {'turma': turma}
    )

# =============================================================================
# INSCRIÇÕES
# =============================================================================

@login_required
@permission_required('fitlife.add_inscricao', raise_exception=True)
def inscrever_aluno(request, cod_turma):
    turma = get_object_or_404(Turma, cod_turma=cod_turma)

    if turma.esta_lotada():
        return render(request, 'fitlife/detalhe_turma.html', {
            'turma':      turma,
            'inscricoes': turma.inscricoes.select_related('cpf_aluno'),
            'erro':       'Turma lotada! Não é possível inscrever mais alunos.',
        })

    if request.method == 'POST':
        aluno = get_object_or_404(Aluno, cpf=request.POST.get('cpf_aluno'))

        if Inscricao.objects.filter(cpf_aluno=aluno, cod_turma=turma).exists():
            return render(request, 'fitlife/inscrever_aluno.html', {
                'turma':  turma,
                'alunos': Aluno.objects.all(),
                'erro':   'Este aluno já está inscrito nesta turma.',
            })

        Inscricao.objects.create(cpf_aluno=aluno, cod_turma=turma)
        messages.success(request, 'Aluno inscrito com sucesso!')
        return redirect('detalhe_turma', cod_turma=cod_turma)

    return render(request, 'fitlife/inscrever_aluno.html', {
        'turma':  turma,
        'alunos': Aluno.objects.all(),
    })


@login_required
@permission_required('fitlife.delete_inscricao', raise_exception=True)
def cancelar_inscricao(request, cod_turma, cpf_aluno):
    inscricao = get_object_or_404(Inscricao, cod_turma=cod_turma, cpf_aluno=cpf_aluno)

    if request.method == 'POST':
        inscricao.delete()
        messages.success(request, 'Inscrição cancelada com sucesso!')
        return redirect('detalhe_turma', cod_turma=cod_turma)

    return render(
        request,
        'fitlife/cancelar_inscricao.html',
        {'inscricao': inscricao}
    )
    
# =============================================================================
# PROFESSORES
# =============================================================================

@login_required
@permission_required('fitlife.view_professor', raise_exception=True)
def listar_professores(request):
    professores = Professor.objects.all()

    busca = request.GET.get('busca')
    ordem = request.GET.get('ordem')

    if busca:
        professores = professores.filter(nome_prof__icontains=busca)

    if ordem == 'nome_za':
        professores = professores.order_by('-nome_prof')
    elif ordem == 'vinculo':
        professores = professores.order_by('nome_prof')
    else:
        professores = professores.order_by('nome_prof')

    return render(
        request,
        'fitlife/listar_professores.html',
        {
            'professores': professores,
            'busca':       busca,
            'ordem':       ordem,
        }
    )

@login_required
@permission_required('fitlife.view_professor', raise_exception=True)
def detalhe_professor(request, cref):
    professor = get_object_or_404(Professor, cref=cref)

    return render(
        request,
        'fitlife/detalhe_professor.html',
        {'professor': professor}
    )

# =============================================================================
# UNIDADES
# =============================================================================

@login_required
@permission_required('fitlife.view_unidade', raise_exception=True)
def listar_unidades(request):
    unidades = Unidade.objects.all()

    busca = request.GET.get('busca')
    ordem = request.GET.get('ordem')

    if busca:
        unidades = unidades.filter(endereco__icontains=busca)

    if ordem == 'endereco_za':
        unidades = unidades.order_by('-endereco')
    else:
        unidades = unidades.order_by('cod_unidade')

    return render(
        request,
        'fitlife/listar_unidades.html',
        {
            'unidades': unidades,
            'busca':    busca,
            'ordem':    ordem,
        }
    )
    
@login_required
@permission_required('fitlife.view_unidade', raise_exception=True)
def detalhe_unidade(request, cod_unidade):
    unidade = get_object_or_404(Unidade, cod_unidade=cod_unidade)

    return render(
        request,
        'fitlife/detalhe_unidade.html',
        {'unidade': unidade}
    )
    
# =============================================================================
# HOME
# =============================================================================

@login_required
def home(request):
    total_alunos       = Aluno.objects.count()
    total_turmas       = Turma.objects.count()
    total_professores  = Professor.objects.count()
    total_unidades     = Unidade.objects.count()
    pagamentos_pendentes = Pagamento.objects.filter(status_pag='Pendente').count()
    pagamentos_atrasados = Pagamento.objects.filter(status_pag='Atrasado').count()
    turmas_lotadas     = sum(1 for t in Turma.objects.all() if t.esta_lotada())
    total_inscricoes   = Inscricao.objects.count()

    return render(request, 'fitlife/home.html', {
        'total_alunos':          total_alunos,
        'total_turmas':          total_turmas,
        'total_professores':     total_professores,
        'total_unidades':        total_unidades,
        'pagamentos_pendentes':  pagamentos_pendentes,
        'pagamentos_atrasados':  pagamentos_atrasados,
        'turmas_lotadas':        turmas_lotadas,
        'total_inscricoes':      total_inscricoes,
    })
