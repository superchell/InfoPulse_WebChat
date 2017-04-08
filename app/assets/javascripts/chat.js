'use strict';

var socket = new WebSocket('ws://127.0.0.1:3000/chat_handler');

var angular_ap = angular.module('web-chat', []);

angular_ap.controller('web-chat-controller', function ($scope) {
   $scope.setItem = function (items) {
       $scope.items = items;
   }

   $scope.changeUser = function (item) {
       document.getElementById('input-message').value = item+':';
   }
});

socket.onopen = function(){
    registration_user();
    console.log('connected');
};

socket.onclose = function(p){
    if (p.wasClean){
        console.log('closed')
    }
    else {
        console.log('closed with error')
    }
};

socket.onerror = function(p){
    console.log('error:' + p)
};

socket.onmessage = function(message) {
    var json_message = JSON.parse(message.data);

    if (typeof json_message.auth !== 'undefined' && json_message.auth == 'yes')
        console.log('auth successful');

    if (typeof json_message.auth !== 'undefined' && json_message.auth == 'no')
        console.log('auth unsuccessful');

    if (typeof json_message.list !== 'undefined') {
        var active_users = json_message.list;

        // отобразить пользователей
        var scope_ang = angular.element(document.getElementById('angular-user-list')).scope();

        scope_ang.$apply(function () {
           scope_ang.setItem(active_users);
        })
    }

    if (typeof json_message.name !== 'undefined') {
        var sender = json_message.name;
        var mess = json_message.message;

        document.getElementById('output-message').value += sender + ':' + mess + '\n';
    }

    if (typeof json_message.disconnect !== 'undefined') {
        window.location.href = '/'
    }
};

function send() {
    var mes = document.getElementById('input-message').value;
    var json_message = {};
    var mes_array = mes.split(':');

    json_message['name'] = mes_array[0];
    json_message['message'] = mes_array[1];

    socket.send(JSON.stringify(json_message));
}

function broadcast() {
    var mes = document.getElementById('input-message').value;
    var json_message = {};

    json_message['broadcast'] = mes;
    socket.send(JSON.stringify(json_message));
}

function disconnect() {
    var mes = document.getElementById('input-message').value;
    var json_message = {};

    json_message['disconnect'] = '';
    socket.send(JSON.stringify(json_message));
}

function registrationUser() {
    var session_id = getCookie('_webchat_session');
    var json_message = {};

    json_message['sessionid'] = session_id;
    socket.send(JSON.stringify(json_message));
}

function getCookie(name) {
    var matches = document.cookie.match(new RegExp(
        "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g,
            '\\$1') + "=([^;]*)"));
    return matches ? decodeURIComponent(matches[1]) : undefined;
}

function attach() {
    var but_send = document.getElementById('send');
    but_send.addEventListener('click', send);

    var but_broadcast = document.getElementById('broadcast');
    but_broadcast.addEventListener('click', broadcast);


    var but_disconnect = document.getElementById('disconnect');
    but_disconnect.addEventListener('click', disconnect);
}
