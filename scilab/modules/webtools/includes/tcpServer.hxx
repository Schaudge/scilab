/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2024 - 3DS - Cedric DELAMARRE
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 */

#ifndef __SCI_TCPSERVER_HXX__
#define __SCI_TCPSERVER_HXX__

#include "tcpSession.hxx"
#include "threads/thread.h"
#include "internal.hxx"

extern "C"
{
#include "dynlib_webtools.h"
}

class ScilabServer
{
public:
    typedef std::function<void(std::shared_ptr<CppServer::Asio::TCPSession>&)> OnConnected;
    typedef std::function<void(std::shared_ptr<CppServer::Asio::TCPSession>&)> OnDisconnected;
    typedef std::function<void(int, const std::string&, const std::string&)> OnError;

    void setOnConnected(const OnConnected& func) { m_onConnected = func;}
    void setOnDisconnected(const OnDisconnected& func) { m_onDisconnected = func;}
    void setOnError(const OnError& func) { m_onError = func;}

protected:
    OnConnected m_onConnected;
    OnDisconnected m_onDisconnected;
    OnError m_onError;
};

class WEBTOOLS_IMPEXP SciTcpServer : public CppServer::Asio::TCPServer, public ScilabServer
{
public:
    // use TCPServer constructor
    using CppServer::Asio::TCPServer::TCPServer;

protected:
    // Session factory
    std::shared_ptr<CppServer::Asio::TCPSession> CreateSession(const std::shared_ptr<CppServer::Asio::TCPServer>& server) override
    {
        return std::make_shared<SciTcpSession>(server);
    }

    void onConnected(std::shared_ptr<CppServer::Asio::TCPSession>& session) override
    {
        if(m_onConnected)
        {
            m_onConnected(session);
        }
    }

    void onDisconnected(std::shared_ptr<CppServer::Asio::TCPSession>& session) override
    {
        if(m_onDisconnected)
        {
            m_onDisconnected(session);
        }
    }

    void onError(int error, const std::string& category, const std::string& message) override
    {
        if (m_onError)
        {
            m_onError(error, category, message);
        }
    }
};

#endif /* !__SCI_TCPSERVER_HXX__ */
