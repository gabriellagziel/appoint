"use client";
import React from 'react';
import { TopNav } from './TopNav';

export interface TopBarProps {
  title?: string;
  subtitle?: string;
  actions?: React.ReactNode;
  userMenu?: React.ReactNode;
  onSidebarToggle?: () => void;
}

export function TopBar(props: TopBarProps) {
  return <TopNav onSidebarToggle={props.onSidebarToggle ?? (() => {})} />;
}

export default TopBar;


