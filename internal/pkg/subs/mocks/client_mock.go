// Code generated by MockGen. DO NOT EDIT.
// Source: subs_grpc.pb.go

// Package mocks is a generated GoMock package.
package mocks

import (
	context "context"
	reflect "reflect"

	generated "github.com/go-park-mail-ru/2021_2_A06367/internal/pkg/subs/delivery/grpc/generated"
	gomock "github.com/golang/mock/gomock"
	grpc "google.golang.org/grpc"
)

// MockSubsServiceClient is a mock of SubsServiceClient interface.
type MockSubsServiceClient struct {
	ctrl     *gomock.Controller
	recorder *MockSubsServiceClientMockRecorder
}

// MockSubsServiceClientMockRecorder is the mock recorder for MockSubsServiceClient.
type MockSubsServiceClientMockRecorder struct {
	mock *MockSubsServiceClient
}

// NewMockSubsServiceClient creates a new mock instance.
func NewMockSubsServiceClient(ctrl *gomock.Controller) *MockSubsServiceClient {
	mock := &MockSubsServiceClient{ctrl: ctrl}
	mock.recorder = &MockSubsServiceClientMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use.
func (m *MockSubsServiceClient) EXPECT() *MockSubsServiceClientMockRecorder {
	return m.recorder
}

// GetLicense mocks base method.
func (m *MockSubsServiceClient) GetLicense(ctx context.Context, in *generated.LicenseUUID, opts ...grpc.CallOption) (*generated.License, error) {
	m.ctrl.T.Helper()
	varargs := []interface{}{ctx, in}
	for _, a := range opts {
		varargs = append(varargs, a)
	}
	ret := m.ctrl.Call(m, "GetLicense", varargs...)
	ret0, _ := ret[0].(*generated.License)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// GetLicense indicates an expected call of GetLicense.
func (mr *MockSubsServiceClientMockRecorder) GetLicense(ctx, in interface{}, opts ...interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	varargs := append([]interface{}{ctx, in}, opts...)
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetLicense", reflect.TypeOf((*MockSubsServiceClient)(nil).GetLicense), varargs...)
}

// SetLicense mocks base method.
func (m *MockSubsServiceClient) SetLicense(ctx context.Context, in *generated.LicenseReq, opts ...grpc.CallOption) (*generated.License, error) {
	m.ctrl.T.Helper()
	varargs := []interface{}{ctx, in}
	for _, a := range opts {
		varargs = append(varargs, a)
	}
	ret := m.ctrl.Call(m, "SetLicense", varargs...)
	ret0, _ := ret[0].(*generated.License)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// SetLicense indicates an expected call of SetLicense.
func (mr *MockSubsServiceClientMockRecorder) SetLicense(ctx, in interface{}, opts ...interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	varargs := append([]interface{}{ctx, in}, opts...)
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "SetLicense", reflect.TypeOf((*MockSubsServiceClient)(nil).SetLicense), varargs...)
}

// MockSubsServiceServer is a mock of SubsServiceServer interface.
type MockSubsServiceServer struct {
	ctrl     *gomock.Controller
	recorder *MockSubsServiceServerMockRecorder
}

// MockSubsServiceServerMockRecorder is the mock recorder for MockSubsServiceServer.
type MockSubsServiceServerMockRecorder struct {
	mock *MockSubsServiceServer
}

// NewMockSubsServiceServer creates a new mock instance.
func NewMockSubsServiceServer(ctrl *gomock.Controller) *MockSubsServiceServer {
	mock := &MockSubsServiceServer{ctrl: ctrl}
	mock.recorder = &MockSubsServiceServerMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use.
func (m *MockSubsServiceServer) EXPECT() *MockSubsServiceServerMockRecorder {
	return m.recorder
}

// GetLicense mocks base method.
func (m *MockSubsServiceServer) GetLicense(arg0 context.Context, arg1 *generated.LicenseUUID) (*generated.License, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetLicense", arg0, arg1)
	ret0, _ := ret[0].(*generated.License)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// GetLicense indicates an expected call of GetLicense.
func (mr *MockSubsServiceServerMockRecorder) GetLicense(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetLicense", reflect.TypeOf((*MockSubsServiceServer)(nil).GetLicense), arg0, arg1)
}

// SetLicense mocks base method.
func (m *MockSubsServiceServer) SetLicense(arg0 context.Context, arg1 *generated.LicenseReq) (*generated.License, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "SetLicense", arg0, arg1)
	ret0, _ := ret[0].(*generated.License)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// SetLicense indicates an expected call of SetLicense.
func (mr *MockSubsServiceServerMockRecorder) SetLicense(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "SetLicense", reflect.TypeOf((*MockSubsServiceServer)(nil).SetLicense), arg0, arg1)
}

// mustEmbedUnimplementedSubsServiceServer mocks base method.
func (m *MockSubsServiceServer) mustEmbedUnimplementedSubsServiceServer() {
	m.ctrl.T.Helper()
	m.ctrl.Call(m, "mustEmbedUnimplementedSubsServiceServer")
}

// mustEmbedUnimplementedSubsServiceServer indicates an expected call of mustEmbedUnimplementedSubsServiceServer.
func (mr *MockSubsServiceServerMockRecorder) mustEmbedUnimplementedSubsServiceServer() *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "mustEmbedUnimplementedSubsServiceServer", reflect.TypeOf((*MockSubsServiceServer)(nil).mustEmbedUnimplementedSubsServiceServer))
}

// MockUnsafeSubsServiceServer is a mock of UnsafeSubsServiceServer interface.
type MockUnsafeSubsServiceServer struct {
	ctrl     *gomock.Controller
	recorder *MockUnsafeSubsServiceServerMockRecorder
}

// MockUnsafeSubsServiceServerMockRecorder is the mock recorder for MockUnsafeSubsServiceServer.
type MockUnsafeSubsServiceServerMockRecorder struct {
	mock *MockUnsafeSubsServiceServer
}

// NewMockUnsafeSubsServiceServer creates a new mock instance.
func NewMockUnsafeSubsServiceServer(ctrl *gomock.Controller) *MockUnsafeSubsServiceServer {
	mock := &MockUnsafeSubsServiceServer{ctrl: ctrl}
	mock.recorder = &MockUnsafeSubsServiceServerMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use.
func (m *MockUnsafeSubsServiceServer) EXPECT() *MockUnsafeSubsServiceServerMockRecorder {
	return m.recorder
}

// mustEmbedUnimplementedSubsServiceServer mocks base method.
func (m *MockUnsafeSubsServiceServer) mustEmbedUnimplementedSubsServiceServer() {
	m.ctrl.T.Helper()
	m.ctrl.Call(m, "mustEmbedUnimplementedSubsServiceServer")
}

// mustEmbedUnimplementedSubsServiceServer indicates an expected call of mustEmbedUnimplementedSubsServiceServer.
func (mr *MockUnsafeSubsServiceServerMockRecorder) mustEmbedUnimplementedSubsServiceServer() *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "mustEmbedUnimplementedSubsServiceServer", reflect.TypeOf((*MockUnsafeSubsServiceServer)(nil).mustEmbedUnimplementedSubsServiceServer))
}
