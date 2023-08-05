from django.shortcuts import render, redirect
from django.http import JsonResponse
from django.contrib.auth import get_user_model,login,logout,authenticate
from .forms import RegistrationForm
from django.contrib import messages
from django.contrib.auth.forms import AuthenticationForm
from .models import QnA
import openai
from .key import chatgpt_api_key


openai.api_key = chatgpt_api_key

#register view
def register(request):
    if request.user.is_authenticated:
        return redirect('/chatbot/home')
    
    if request.method == "POST":
        form = RegistrationForm(request.POST)
        if form.is_valid():
            form.save()
            messages.success(request,"Your account has been created successfully!")
            return redirect('/chatbot/login')
        else:
            messages.warning(request,"Something went wrong!")
    else:
        form = RegistrationForm()
    
    return render(request,'chatbot/register.html',{'form':form})


# login view
def login_func(request):
    if request.user.is_authenticated:
        return redirect('/chatbot/home')
    if request.method == 'POST':
        form = AuthenticationForm(request,data=request.POST)
        if form.is_valid():
            username = form.cleaned_data['username']
            password = form.cleaned_data['password']
            user = authenticate(username=username,password=password)
            print("user : ",user)
            if user is not None:
                login(request,user)
                messages.success(request,'You have been logged in successfully!')
                return redirect('/chatbot/home')
            else:
                messages.warning(request,'Invalid credentials!')
                return redirect('/chatbot/login')
        else:
            messages.warning(request,'Something went wrong!')
            return redirect('/chatbot/login')
    else:
        form = AuthenticationForm()
    return render(request,'chatbot/login.html',{'form':form})

#logout view
def logout_func(request):
    logout(request)
    messages.success(request,'You have been logged out successfully!')
    return redirect('/chatbot/login')

def home(request):
    if not request.user.is_authenticated:
        return redirect('/chatbot/login')
    
    if request.method == 'POST':
        try:
            quest = request.POST.get('quest')
            print("quest : ",quest)
            # using chatgpt api 
            response = openai.ChatCompletion.create(
                model='gpt-3.5-turbo',
                messages=[{"role": "user", "content": quest}],
                max_tokens = 100,
                temperature = 0.7,
            )
            ans = response.choices[0].message.content
            print("chatgpt response : ",ans)

            # saving the data into the database 
            qna = QnA(question=quest,answer=ans,user=request.user)
            qna.save()
            data = {
                'answer' : ans,
                'error': False,
                'msg': ''
            }
            return JsonResponse(data,safe=False)
        except Exception as e:
            print("error occured : ",e)
            data = {
                'answer' : '',
                'error': True,
                'msg': e
            }
            return JsonResponse(data,safe=False)
    else:
      return render(request,'chatbot/home.html')

def history(request):
    if not request.user.is_authenticated:
        return redirect('/chatbot/login')
    data = QnA.objects.filter(user=request.user)
    return render(request,'chatbot/history.html',{'data':data})