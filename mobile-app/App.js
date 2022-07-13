/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, { useState, useEffect } from 'react';
import type {Node} from 'react';
import {
  Alert,
  SafeAreaView,
  ScrollView,
  Button,
  View,
  Text,
} from 'react-native';

import jwt_decode from 'jwt-decode';
import { prefetchConfiguration, authorize, refresh, logout } from 'react-native-app-auth';
import * as Keychain from 'react-native-keychain';

import {
  Header,
} from 'react-native/Libraries/NewAppScreen';

const ISSUER = "https://10.0.2.2:8443/auth/realms/member-stage";

const defaultAuthState = {
  accessToken: '',
  accessTokenExpirationDate: '',
  refreshToken: '',
  idToken: '',
  decodedIdToken: {},
  scopes: []
};

// Base config
const config = {
  issuer: ISSUER,
  clientId: 'mobile_app',
  redirectUrl: 'com.mobileapp.auth:/oauth2redirect',
  scopes: ['openid', 'email', 'profile', 'offline_access'],
  usePKCE: true,
  dangerouslyAllowInsecureHttpRequests: __DEV__,
  additionalParameters: { "prompt": "login" }
};

const App: () => Node = () => {
  const [authState, setAuthState] = useState(defaultAuthState);

  useEffect(async () => {
    await restoreSecureAuthState();

    prefetchConfiguration({
      warmAndPrefetchChrome: true,
      connectionTimeoutSeconds: 5,
      ...config,
    });
  }, []);

  const setSecureAuthState = (authState) => {
    setAuthState(authState);
    return Keychain.setGenericPassword('authState', JSON.stringify(authState));
  };

  const restoreSecureAuthState = async () => {
    const credentials = await Keychain.getGenericPassword();
    if (credentials)
      setAuthState(JSON.parse(credentials.password));
  };

  const resetSecureAuthState = () => {
    setAuthState(defaultAuthState);
    return Keychain.resetGenericPassword();
  };

  const makeLogin = async () => {
    // use the client to make the auth request and receive the authState
    try {
      const newAuthState = await authorize(config);
      newAuthState.decodedIdToken = jwt_decode(newAuthState.idToken);
      
      const result = await setSecureAuthState(newAuthState);
      
      if (!result) 
        throw Error('Unable to use secure storage!');
    } catch (error) {
      if (error.message == 'User cancelled flow') return;

      Alert.alert('Failed to log in', error.message);
    }
  };

  const makeRefresh = async () => {
    try {
      const newAuthState = await refresh(config, {
        refreshToken: authState.refreshToken
      });
      newAuthState.decodedIdToken = jwt_decode(newAuthState.idToken);

      const result = await setSecureAuthState({
        ...authState,
        ...newAuthState
      });

      if (!result) 
        throw Error('Unable to use secure storage!');
    } catch (error) {
      Alert.alert('Failed to refresh token', error.message);
    }
  };
  
  const makeLogout = async () => {
    if (authState == null)
      return;

    try {  
      await logout({ issuer: ISSUER }, {
        idToken: authState.idToken,
        postLogoutRedirectUrl: 'com.mobileapp.auth:/oauth2redirect',
      });

      await resetSecureAuthState();
    } catch (error) {
      Alert.alert('Failed to logout', error.message);
    }
  };

  return (
    <SafeAreaView>
      <ScrollView
        contentInsetAdjustmentBehavior="automatic">
        <Header />
          {!!authState.accessToken ? (
            <View>
              <Text>idToken (decoded)</Text>
              <Text>{JSON.stringify(authState.decodedIdToken)}</Text>
              <Text>accessToken</Text>
              <Text>{authState.accessToken}</Text>
              <Text>accessTokenExpirationDate</Text>
              <Text>{authState.accessTokenExpirationDate}</Text>
              <Text>refreshToken</Text>
              <Text>{authState.refreshToken}</Text>
              <Text>scopes</Text>
              <Text>{authState.scopes.join(', ')}</Text>
            </View>
          ) : null}

          <View>
            {!authState.accessToken ? (
              <>
                <Button
                  onPress={() => makeLogin()}
                  title="Login"
                  color="#DA2536"
                />
              </>
            ) : (
              <Button onPress={() => makeLogout()} title="Logout" color="#EF525B" />
            )}
            {!!authState.refreshToken ? (
              <Button onPress={() => makeRefresh()} title="Refresh" color="#24C2CB" />
            ) : null}
          </View>

      </ScrollView>
    </SafeAreaView>
  );
};

export default App;
