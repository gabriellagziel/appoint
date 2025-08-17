"use client"

import * as React from "react"
import { cn } from "@/lib/utils"

export const Table = React.forwardRef<HTMLTableElement, React.ComponentProps<"table">>(
  ({ className, ...props }, ref) => (
    <div className="w-full overflow-x-auto">
      <table
        ref={ref}
        className={cn(
          "w-full caption-bottom text-sm border border-gray-200 rounded-lg overflow-hidden",
          className
        )}
        {...props}
      />
    </div>
  )
)
Table.displayName = "Table"

export const TableHeader = React.forwardRef<
  HTMLTableSectionElement,
  React.ComponentProps<"thead">
>(({ className, ...props }, ref) => (
  <thead
    ref={ref}
    className={cn("[&_tr]:border-b bg-gray-50", className)}
    {...props}
  />
))
TableHeader.displayName = "TableHeader"

export const TableBody = React.forwardRef<
  HTMLTableSectionElement,
  React.ComponentProps<"tbody">
>(({ className, ...props }, ref) => (
  <tbody
    ref={ref}
    className={cn(
      "divide-y divide-gray-200 [&_tr:nth-child(even)]:bg-gray-50",
      className
    )}
    {...props}
  />
))
TableBody.displayName = "TableBody"

export const TableFooter = React.forwardRef<
  HTMLTableSectionElement,
  React.ComponentProps<"tfoot">
>(({ className, ...props }, ref) => (
  <tfoot ref={ref} className={cn("bg-gray-50 font-medium", className)} {...props} />
))
TableFooter.displayName = "TableFooter"

export const TableRow = React.forwardRef<HTMLTableRowElement, React.ComponentProps<"tr">>(
  ({ className, ...props }, ref) => (
    <tr
      ref={ref}
      className={cn(
        "hover:bg-gray-50/70 data-[state=selected]:bg-gray-100",
        className
      )}
      {...props}
    />
  )
)
TableRow.displayName = "TableRow"

export const TableHead = React.forwardRef<HTMLTableCellElement, React.ComponentProps<"th">>(
  ({ className, ...props }, ref) => (
    <th
      ref={ref}
      className={cn(
        "px-4 py-3 text-left align-middle text-xs font-medium text-gray-600 uppercase tracking-wider",
        className
      )}
      {...props}
    />
  )
)
TableHead.displayName = "TableHead"

export const TableCell = React.forwardRef<HTMLTableCellElement, React.ComponentProps<"td">>(
  ({ className, ...props }, ref) => (
    <td
      ref={ref}
      className={cn("px-4 py-3 align-middle text-gray-900", className)}
      {...props}
    />
  )
)
TableCell.displayName = "TableCell"

export const TableCaption = React.forwardRef<
  HTMLTableCaptionElement,
  React.ComponentProps<"caption">
>(({ className, ...props }, ref) => (
  <caption
    ref={ref}
    className={cn("mt-4 text-sm text-gray-500", className)}
    {...props}
  />
))
TableCaption.displayName = "TableCaption"


