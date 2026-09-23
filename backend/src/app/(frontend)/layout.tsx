import type { ReactNode } from 'react'
import { Barlow_Condensed, Figtree } from 'next/font/google'

import './globals.css'

const display = Barlow_Condensed({
  subsets: ['latin'],
  weight: ['600', '700'],
  variable: '--font-display',
})

const body = Figtree({
  subsets: ['latin'],
  variable: '--font-body',
})

export const metadata = {
  title: 'StayAble',
  description: 'Programs, actual sessions, and coaching — planned work stays separate from what you did.',
}

export default function FrontendLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en" className={`${display.variable} ${body.variable}`}>
      <body>{children}</body>
    </html>
  )
}
