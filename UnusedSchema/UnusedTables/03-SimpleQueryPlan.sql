DECLARE @x XML = '<ShowPlanXML xmlns="http://schemas.microsoft.com/sqlserver/2004/07/showplan" Version="1.1" Build="10.50.1600.1">
  <BatchSequence>
    <Batch>
      <Statements>
        <StmtSimple StatementText="CREATE PROCEDURE [dbo].[uspGetWhereUsedProductID]&#xD;&#xA;@StartProductID [int],&#xD;&#xA;@CheckDate [datetime]&#xD;&#xA;AS&#xD;&#xA;BEGIN&#xD;&#xA;SET NOCOUNT ON;&#xD;" StatementId="1" StatementCompId="3" StatementType="SET ON/OFF" />
        <StmtSimple StatementText="&#xA;WITH [BOM_cte]([ProductAssemblyID], [ComponentID], [ComponentDesc], [PerAssemblyQty], [StandardCost], [ListPrice], [BOMLevel], [RecursionLevel]) -- CTE name and columns&#xD;&#xA;AS (&#xD;&#xA;SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], 0 -- Get the initial list of components for the bike assembly&#xD;&#xA;FROM [Production].[BillOfMaterials] b&#xD;&#xA;INNER JOIN [Production].[Product] p &#xD;&#xA;ON b.[ProductAssemblyID] = p.[ProductID] &#xD;&#xA;WHERE b.[ComponentID] = @StartProductID &#xD;&#xA;AND @CheckDate &gt;= b.[StartDate] &#xD;&#xA;AND @CheckDate &lt;= ISNULL(b.[EndDate], @CheckDate)&#xD;&#xA;UNION ALL&#xD;&#xA;SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], [RecursionLevel] + 1 -- Join recursive member to anchor&#xD;&#xA;FROM [BOM_cte] cte&#xD;&#xA;INNER JOIN [Production].[BillOfMaterials] b &#xD;&#xA;ON cte.[ProductAssemblyID] = b.[ComponentID]&#xD;&#xA;INNER JOIN [Production].[Product] p &#xD;&#xA;ON b.[ProductAssemblyID] = p.[ProductID] &#xD;&#xA;WHERE @CheckDate &gt;= b.[StartDate] &#xD;&#xA;AND @CheckDate &lt;= ISNULL(b.[EndDate], @CheckDate)&#xD;&#xA;)&#xD;&#xA;SELECT b.[ProductAssemblyID], b.[ComponentID], b.[ComponentDesc], SUM(b.[PerAssemblyQty]) AS [TotalQuantity] , b.[StandardCost], b.[ListPrice], b.[BOMLevel], b.[RecursionLevel]&#xD;&#xA;FROM [BOM_cte] b&#xD;&#xA;GROUP BY b.[ComponentID], b.[ComponentDesc], b.[ProductAssemblyID], b.[BOMLevel], b.[RecursionLevel], b.[StandardCost], b.[ListPrice]&#xD;&#xA;ORDER BY b.[BOMLevel], b.[ProductAssemblyID], b.[ComponentID]&#xD;&#xA;OPTION (MAXRECURSION 25) &#xD;" StatementId="2" StatementCompId="4" StatementType="SELECT" StatementSubTreeCost="0.169092" StatementEstRows="8.37521" StatementOptmLevel="FULL" QueryHash="0xBAD44EF2B1FD0329" QueryPlanHash="0x5D22DC4252C60CCB" StatementOptmEarlyAbortReason="GoodEnoughPlanFound">
          <StatementSetOptions QUOTED_IDENTIFIER="true" ARITHABORT="true" CONCAT_NULL_YIELDS_NULL="true" ANSI_NULLS="true" ANSI_PADDING="true" ANSI_WARNINGS="true" NUMERIC_ROUNDABORT="false" />
          <QueryPlan CachedPlanSize="72" CompileTime="122" CompileCPU="122" CompileMemory="856">
            <RelOp NodeId="0" PhysicalOp="Stream Aggregate" LogicalOp="Aggregate" EstimateRows="8.37521" EstimateIO="0" EstimateCPU="9.21273e-006" AvgRowSize="108" EstimatedTotalSubtreeCost="0.169092" Parallel="0" EstimateRebinds="0" EstimateRewinds="0">
              <OutputList>
                <ColumnReference Column="Recr1018" />
                <ColumnReference Column="Recr1019" />
                <ColumnReference Column="Recr1020" />
                <ColumnReference Column="Recr1022" />
                <ColumnReference Column="Recr1023" />
                <ColumnReference Column="Recr1024" />
                <ColumnReference Column="Recr1025" />
                <ColumnReference Column="Expr1026" />
              </OutputList>
              <StreamAggregate>
                <DefinedValues>
                  <DefinedValue>
                    <ColumnReference Column="Expr1026" />
                    <ScalarOperator ScalarString="SUM([Recr1021])">
                      <Aggregate Distinct="0" AggType="SUM">
                        <ScalarOperator>
                          <Identifier>
                            <ColumnReference Column="Recr1021" />
                          </Identifier>
                        </ScalarOperator>
                      </Aggregate>
                    </ScalarOperator>
                  </DefinedValue>
                </DefinedValues>
                <GroupBy>
                  <ColumnReference Column="Recr1024" />
                  <ColumnReference Column="Recr1018" />
                  <ColumnReference Column="Recr1019" />
                  <ColumnReference Column="Recr1020" />
                  <ColumnReference Column="Recr1025" />
                  <ColumnReference Column="Recr1022" />
                  <ColumnReference Column="Recr1023" />
                </GroupBy>
                <RelOp NodeId="1" PhysicalOp="Sort" LogicalOp="Sort" EstimateRows="8.37521" EstimateIO="0.0112613" EstimateCPU="0.000140156" AvgRowSize="96" EstimatedTotalSubtreeCost="0.169083" Parallel="0" EstimateRebinds="0" EstimateRewinds="0">
                  <OutputList>
                    <ColumnReference Column="Recr1018" />
                    <ColumnReference Column="Recr1019" />
                    <ColumnReference Column="Recr1020" />
                    <ColumnReference Column="Recr1021" />
                    <ColumnReference Column="Recr1022" />
                    <ColumnReference Column="Recr1023" />
                    <ColumnReference Column="Recr1024" />
                    <ColumnReference Column="Recr1025" />
                  </OutputList>
                  <MemoryFractions Input="1" Output="1" />
                  <Sort Distinct="0">
                    <OrderBy>
                      <OrderByColumn Ascending="1">
                        <ColumnReference Column="Recr1024" />
                      </OrderByColumn>
                      <OrderByColumn Ascending="1">
                        <ColumnReference Column="Recr1018" />
                      </OrderByColumn>
                      <OrderByColumn Ascending="1">
                        <ColumnReference Column="Recr1019" />
                      </OrderByColumn>
                      <OrderByColumn Ascending="1">
                        <ColumnReference Column="Recr1020" />
                      </OrderByColumn>
                      <OrderByColumn Ascending="1">
                        <ColumnReference Column="Recr1025" />
                      </OrderByColumn>
                      <OrderByColumn Ascending="1">
                        <ColumnReference Column="Recr1022" />
                      </OrderByColumn>
                      <OrderByColumn Ascending="1">
                        <ColumnReference Column="Recr1023" />
                      </OrderByColumn>
                    </OrderBy>
                    <RelOp NodeId="2" PhysicalOp="Index Spool" LogicalOp="Lazy Spool" EstimateRows="8.37521" EstimateIO="0" EstimateCPU="4.1876e-008" AvgRowSize="96" EstimatedTotalSubtreeCost="0.157682" Parallel="0" EstimateRebinds="0" EstimateRewinds="0">
                      <OutputList>
                        <ColumnReference Column="Expr1030" />
                        <ColumnReference Column="Recr1018" />
                        <ColumnReference Column="Recr1019" />
                        <ColumnReference Column="Recr1020" />
                        <ColumnReference Column="Recr1021" />
                        <ColumnReference Column="Recr1022" />
                        <ColumnReference Column="Recr1023" />
                        <ColumnReference Column="Recr1024" />
                        <ColumnReference Column="Recr1025" />
                      </OutputList>
                      <Spool Stack="1">
                        <RelOp NodeId="3" PhysicalOp="Concatenation" LogicalOp="Concatenation" EstimateRows="8.37521" EstimateIO="0" EstimateCPU="8.37521e-009" AvgRowSize="96" EstimatedTotalSubtreeCost="0.145225" Parallel="0" EstimateRebinds="0" EstimateRewinds="0">
                          <OutputList>
                            <ColumnReference Column="Expr1030" />
                            <ColumnReference Column="Recr1018" />
                            <ColumnReference Column="Recr1019" />
                            <ColumnReference Column="Recr1020" />
                            <ColumnReference Column="Recr1021" />
                            <ColumnReference Column="Recr1022" />
                            <ColumnReference Column="Recr1023" />
                            <ColumnReference Column="Recr1024" />
                            <ColumnReference Column="Recr1025" />
                          </OutputList>
                          <Concat>
                            <DefinedValues>
                              <DefinedValue>
                                <ColumnReference Column="Expr1030" />
                                <ColumnReference Column="Expr1027" />
                                <ColumnReference Column="Expr1029" />
                              </DefinedValue>
                              <DefinedValue>
                                <ColumnReference Column="Recr1018" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                              </DefinedValue>
                              <DefinedValue>
                                <ColumnReference Column="Recr1019" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                              </DefinedValue>
                              <DefinedValue>
                                <ColumnReference Column="Recr1020" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="Name" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="Name" />
                              </DefinedValue>
                              <DefinedValue>
                                <ColumnReference Column="Recr1021" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="PerAssemblyQty" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="PerAssemblyQty" />
                              </DefinedValue>
                              <DefinedValue>
                                <ColumnReference Column="Recr1022" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="StandardCost" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="StandardCost" />
                              </DefinedValue>
                              <DefinedValue>
                                <ColumnReference Column="Recr1023" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="ListPrice" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="ListPrice" />
                              </DefinedValue>
                              <DefinedValue>
                                <ColumnReference Column="Recr1024" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="BOMLevel" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="BOMLevel" />
                              </DefinedValue>
                              <DefinedValue>
                                <ColumnReference Column="Recr1025" />
                                <ColumnReference Column="Expr1004" />
                                <ColumnReference Column="Expr1017" />
                              </DefinedValue>
                            </DefinedValues>
                            <RelOp NodeId="4" PhysicalOp="Compute Scalar" LogicalOp="Compute Scalar" EstimateRows="1" EstimateIO="0" EstimateCPU="8.37521e-008" AvgRowSize="96" EstimatedTotalSubtreeCost="8.37521e-008" Parallel="0" EstimateRebinds="8.37521" EstimateRewinds="0">
                              <OutputList>
                                <ColumnReference Column="Expr1027" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="Name" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="PerAssemblyQty" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="StandardCost" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="ListPrice" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="BOMLevel" />
                                <ColumnReference Column="Expr1004" />
                              </OutputList>
                              <ComputeScalar>
                                <DefinedValues>
                                  <DefinedValue>
                                    <ColumnReference Column="Expr1027" />
                                    <ScalarOperator ScalarString="(0)">
                                      <Const ConstValue="(0)" />
                                    </ScalarOperator>
                                  </DefinedValue>
                                </DefinedValues>
                                <RelOp NodeId="5" PhysicalOp="Compute Scalar" LogicalOp="Compute Scalar" EstimateRows="1" EstimateIO="0" EstimateCPU="1e-007" AvgRowSize="96" EstimatedTotalSubtreeCost="0.0210877" Parallel="0" EstimateRebinds="0" EstimateRewinds="0">
                                  <OutputList>
                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="BOMLevel" />
                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="PerAssemblyQty" />
                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="Name" />
                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="StandardCost" />
                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="ListPrice" />
                                    <ColumnReference Column="Expr1004" />
                                  </OutputList>
                                  <ComputeScalar>
                                    <DefinedValues>
                                      <DefinedValue>
                                        <ColumnReference Column="Expr1004" />
                                        <ScalarOperator ScalarString="(0)">
                                          <Const ConstValue="(0)" />
                                        </ScalarOperator>
                                      </DefinedValue>
                                    </DefinedValues>
                                    <RelOp NodeId="6" PhysicalOp="Nested Loops" LogicalOp="Inner Join" EstimateRows="1" EstimateIO="0" EstimateCPU="4.18e-006" AvgRowSize="92" EstimatedTotalSubtreeCost="0.0210876" Parallel="0" EstimateRebinds="0" EstimateRewinds="0">
                                      <OutputList>
                                        <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                        <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                                        <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="BOMLevel" />
                                        <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="PerAssemblyQty" />
                                        <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="Name" />
                                        <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="StandardCost" />
                                        <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="ListPrice" />
                                      </OutputList>
                                      <NestedLoops Optimized="0">
                                        <OuterReferences>
                                          <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                        </OuterReferences>
                                        <RelOp NodeId="7" PhysicalOp="Nested Loops" LogicalOp="Inner Join" EstimateRows="1" EstimateIO="0" EstimateCPU="4.18e-006" AvgRowSize="30" EstimatedTotalSubtreeCost="0.0177996" Parallel="0" EstimateRebinds="0" EstimateRewinds="0">
                                          <OutputList>
                                            <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                            <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                                            <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="BOMLevel" />
                                            <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="PerAssemblyQty" />
                                          </OutputList>
                                          <NestedLoops Optimized="0">
                                            <OuterReferences>
                                              <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                              <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                                              <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="StartDate" />
                                            </OuterReferences>
                                            <RelOp NodeId="8" PhysicalOp="Index Scan" LogicalOp="Index Scan" EstimateRows="1" EstimateIO="0.00905093" EstimateCPU="0.0031039" AvgRowSize="23" EstimatedTotalSubtreeCost="0.0121548" TableCardinality="2679" Parallel="0" EstimateRebinds="0" EstimateRewinds="0">
                                              <OutputList>
                                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="StartDate" />
                                              </OutputList>
                                              <IndexScan Ordered="0" ForcedIndex="0" ForceSeek="0" NoExpandHint="0">
                                                <DefinedValues>
                                                  <DefinedValue>
                                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                                  </DefinedValue>
                                                  <DefinedValue>
                                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                                                  </DefinedValue>
                                                  <DefinedValue>
                                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="StartDate" />
                                                  </DefinedValue>
                                                </DefinedValues>
                                                <Object Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Index="[PK_BillOfMaterials_BillOfMaterialsID]" Alias="[b]" TableReferenceId="1" IndexKind="NonClustered" />
                                                <Predicate>
                                                  <ScalarOperator ScalarString="[AdventureWorks].[Production].[BillOfMaterials].[ComponentID] as [b].[ComponentID]=[@StartProductID] AND [@CheckDate]&gt;=[AdventureWorks].[Production].[BillOfMaterials].[StartDate] as [b].[StartDate]">
                                                    <Logical Operation="AND">
                                                      <ScalarOperator>
                                                        <Compare CompareOp="EQ">
                                                          <ScalarOperator>
                                                            <Identifier>
                                                              <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                                                            </Identifier>
                                                          </ScalarOperator>
                                                          <ScalarOperator>
                                                            <Identifier>
                                                              <ColumnReference Column="@StartProductID" />
                                                            </Identifier>
                                                          </ScalarOperator>
                                                        </Compare>
                                                      </ScalarOperator>
                                                      <ScalarOperator>
                                                        <Compare CompareOp="GE">
                                                          <ScalarOperator>
                                                            <Identifier>
                                                              <ColumnReference Column="@CheckDate" />
                                                            </Identifier>
                                                          </ScalarOperator>
                                                          <ScalarOperator>
                                                            <Identifier>
                                                              <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="StartDate" />
                                                            </Identifier>
                                                          </ScalarOperator>
                                                        </Compare>
                                                      </ScalarOperator>
                                                    </Logical>
                                                  </ScalarOperator>
                                                </Predicate>
                                              </IndexScan>
                                            </RelOp>
                                            <RelOp NodeId="10" PhysicalOp="Clustered Index Seek" LogicalOp="Clustered Index Seek" EstimateRows="1" EstimateIO="0.003125" EstimateCPU="0.0001581" AvgRowSize="22" EstimatedTotalSubtreeCost="0.0032831" TableCardinality="2679" Parallel="0" EstimateRebinds="0" EstimateRewinds="0">
                                              <OutputList>
                                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="BOMLevel" />
                                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="PerAssemblyQty" />
                                              </OutputList>
                                              <IndexScan Lookup="1" Ordered="1" ScanDirection="FORWARD" ForcedIndex="0" ForceSeek="0" NoExpandHint="0">
                                                <DefinedValues>
                                                  <DefinedValue>
                                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="BOMLevel" />
                                                  </DefinedValue>
                                                  <DefinedValue>
                                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="PerAssemblyQty" />
                                                  </DefinedValue>
                                                </DefinedValues>
                                                <Object Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Index="[AK_BillOfMaterials_ProductAssemblyID_ComponentID_StartDate]" Alias="[b]" TableReferenceId="-1" IndexKind="Clustered" />
                                                <SeekPredicates>
                                                  <SeekPredicateNew>
                                                    <SeekKeys>
                                                      <Prefix ScanType="EQ">
                                                        <RangeColumns>
                                                          <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                                          <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                                                          <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="StartDate" />
                                                        </RangeColumns>
                                                        <RangeExpressions>
                                                          <ScalarOperator ScalarString="[AdventureWorks].[Production].[BillOfMaterials].[ProductAssemblyID] as [b].[ProductAssemblyID]">
                                                            <Identifier>
                                                              <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                                            </Identifier>
                                                          </ScalarOperator>
                                                          <ScalarOperator ScalarString="[AdventureWorks].[Production].[BillOfMaterials].[ComponentID] as [b].[ComponentID]">
                                                            <Identifier>
                                                              <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                                                            </Identifier>
                                                          </ScalarOperator>
                                                          <ScalarOperator ScalarString="[AdventureWorks].[Production].[BillOfMaterials].[StartDate] as [b].[StartDate]">
                                                            <Identifier>
                                                              <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="StartDate" />
                                                            </Identifier>
                                                          </ScalarOperator>
                                                        </RangeExpressions>
                                                      </Prefix>
                                                    </SeekKeys>
                                                  </SeekPredicateNew>
                                                </SeekPredicates>
                                                <Predicate>
                                                  <ScalarOperator ScalarString="[@CheckDate]&lt;=isnull([AdventureWorks].[Production].[BillOfMaterials].[EndDate] as [b].[EndDate],[@CheckDate])">
                                                    <Compare CompareOp="LE">
                                                      <ScalarOperator>
                                                        <Identifier>
                                                          <ColumnReference Column="@CheckDate" />
                                                        </Identifier>
                                                      </ScalarOperator>
                                                      <ScalarOperator>
                                                        <Intrinsic FunctionName="isnull">
                                                          <ScalarOperator>
                                                            <Identifier>
                                                              <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="EndDate" />
                                                            </Identifier>
                                                          </ScalarOperator>
                                                          <ScalarOperator>
                                                            <Identifier>
                                                              <ColumnReference Column="@CheckDate" />
                                                            </Identifier>
                                                          </ScalarOperator>
                                                        </Intrinsic>
                                                      </ScalarOperator>
                                                    </Compare>
                                                  </ScalarOperator>
                                                </Predicate>
                                              </IndexScan>
                                            </RelOp>
                                          </NestedLoops>
                                        </RelOp>
                                        <RelOp NodeId="16" PhysicalOp="Clustered Index Seek" LogicalOp="Clustered Index Seek" EstimateRows="1" EstimateIO="0.003125" EstimateCPU="0.0001581" AvgRowSize="77" EstimatedTotalSubtreeCost="0.0032831" TableCardinality="504" Parallel="0" EstimateRebinds="0" EstimateRewinds="0">
                                          <OutputList>
                                            <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="Name" />
                                            <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="StandardCost" />
                                            <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="ListPrice" />
                                          </OutputList>
                                          <IndexScan Ordered="1" ScanDirection="FORWARD" ForcedIndex="0" ForceSeek="0" NoExpandHint="0">
                                            <DefinedValues>
                                              <DefinedValue>
                                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="Name" />
                                              </DefinedValue>
                                              <DefinedValue>
                                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="StandardCost" />
                                              </DefinedValue>
                                              <DefinedValue>
                                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="ListPrice" />
                                              </DefinedValue>
                                            </DefinedValues>
                                            <Object Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Index="[PK_Product_ProductID]" Alias="[p]" TableReferenceId="1" IndexKind="Clustered" />
                                            <SeekPredicates>
                                              <SeekPredicateNew>
                                                <SeekKeys>
                                                  <Prefix ScanType="EQ">
                                                    <RangeColumns>
                                                      <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="ProductID" />
                                                    </RangeColumns>
                                                    <RangeExpressions>
                                                      <ScalarOperator ScalarString="[AdventureWorks].[Production].[BillOfMaterials].[ProductAssemblyID] as [b].[ProductAssemblyID]">
                                                        <Identifier>
                                                          <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                                        </Identifier>
                                                      </ScalarOperator>
                                                    </RangeExpressions>
                                                  </Prefix>
                                                </SeekKeys>
                                              </SeekPredicateNew>
                                            </SeekPredicates>
                                          </IndexScan>
                                        </RelOp>
                                      </NestedLoops>
                                    </RelOp>
                                  </ComputeScalar>
                                </RelOp>
                              </ComputeScalar>
                            </RelOp>
                            <RelOp NodeId="23" PhysicalOp="Assert" LogicalOp="Assert" EstimateRows="8.37521" EstimateIO="0" EstimateCPU="7.03517e-007" AvgRowSize="96" EstimatedTotalSubtreeCost="0.124138" Parallel="0" EstimateRebinds="8.37521" EstimateRewinds="0">
                              <OutputList>
                                <ColumnReference Column="Expr1029" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="Name" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="PerAssemblyQty" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="StandardCost" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="ListPrice" />
                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="BOMLevel" />
                                <ColumnReference Column="Expr1017" />
                              </OutputList>
                              <Assert StartupExpression="0">
                                <RelOp NodeId="24" PhysicalOp="Nested Loops" LogicalOp="Inner Join" EstimateRows="8.37521" EstimateIO="0" EstimateCPU="7.03517e-007" AvgRowSize="96" EstimatedTotalSubtreeCost="0.124138" Parallel="0" EstimateRebinds="8.37521" EstimateRewinds="0">
                                  <OutputList>
                                    <ColumnReference Column="Expr1029" />
                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="Name" />
                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="PerAssemblyQty" />
                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="StandardCost" />
                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="ListPrice" />
                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="BOMLevel" />
                                    <ColumnReference Column="Expr1017" />
                                  </OutputList>
                                  <NestedLoops Optimized="0">
                                    <OuterReferences>
                                      <ColumnReference Column="Expr1029" />
                                      <ColumnReference Column="Recr1005" />
                                      <ColumnReference Column="Recr1006" />
                                      <ColumnReference Column="Recr1007" />
                                      <ColumnReference Column="Recr1008" />
                                      <ColumnReference Column="Recr1009" />
                                      <ColumnReference Column="Recr1010" />
                                      <ColumnReference Column="Recr1011" />
                                      <ColumnReference Column="Recr1012" />
                                    </OuterReferences>
                                    <RelOp NodeId="25" PhysicalOp="Compute Scalar" LogicalOp="Compute Scalar" EstimateRows="1" EstimateIO="0" EstimateCPU="8.37521e-008" AvgRowSize="96" EstimatedTotalSubtreeCost="8.37521e-008" Parallel="0" EstimateRebinds="8.37521" EstimateRewinds="0">
                                      <OutputList>
                                        <ColumnReference Column="Expr1029" />
                                        <ColumnReference Column="Recr1005" />
                                        <ColumnReference Column="Recr1006" />
                                        <ColumnReference Column="Recr1007" />
                                        <ColumnReference Column="Recr1008" />
                                        <ColumnReference Column="Recr1009" />
                                        <ColumnReference Column="Recr1010" />
                                        <ColumnReference Column="Recr1011" />
                                        <ColumnReference Column="Recr1012" />
                                      </OutputList>
                                      <ComputeScalar>
                                        <DefinedValues>
                                          <DefinedValue>
                                            <ColumnReference Column="Expr1029" />
                                            <ScalarOperator ScalarString="[Expr1028]+(1)">
                                              <Arithmetic Operation="ADD">
                                                <ScalarOperator>
                                                  <Identifier>
                                                    <ColumnReference Column="Expr1028" />
                                                  </Identifier>
                                                </ScalarOperator>
                                                <ScalarOperator>
                                                  <Const ConstValue="(1)" />
                                                </ScalarOperator>
                                              </Arithmetic>
                                            </ScalarOperator>
                                          </DefinedValue>
                                        </DefinedValues>
                                        <RelOp NodeId="26" PhysicalOp="Table Spool" LogicalOp="Lazy Spool" EstimateRows="1" EstimateIO="0" EstimateCPU="8.37521e-008" AvgRowSize="96" EstimatedTotalSubtreeCost="8.37521e-008" Parallel="0" EstimateRebinds="8.37521" EstimateRewinds="0">
                                          <OutputList>
                                            <ColumnReference Column="Expr1028" />
                                            <ColumnReference Column="Recr1005" />
                                            <ColumnReference Column="Recr1006" />
                                            <ColumnReference Column="Recr1007" />
                                            <ColumnReference Column="Recr1008" />
                                            <ColumnReference Column="Recr1009" />
                                            <ColumnReference Column="Recr1010" />
                                            <ColumnReference Column="Recr1011" />
                                            <ColumnReference Column="Recr1012" />
                                          </OutputList>
                                          <Spool PrimaryNodeId="2" Stack="1" />
                                        </RelOp>
                                      </ComputeScalar>
                                    </RelOp>
                                    <RelOp NodeId="30" PhysicalOp="Compute Scalar" LogicalOp="Compute Scalar" EstimateRows="7.37521" EstimateIO="0" EstimateCPU="7.37521e-007" AvgRowSize="96" EstimatedTotalSubtreeCost="0.124137" Parallel="0" EstimateRebinds="7.37521" EstimateRewinds="0">
                                      <OutputList>
                                        <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                        <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                                        <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="BOMLevel" />
                                        <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="PerAssemblyQty" />
                                        <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="Name" />
                                        <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="StandardCost" />
                                        <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="ListPrice" />
                                        <ColumnReference Column="Expr1017" />
                                      </OutputList>
                                      <ComputeScalar>
                                        <DefinedValues>
                                          <DefinedValue>
                                            <ColumnReference Column="Expr1017" />
                                            <ScalarOperator ScalarString="[Recr1012]+(1)">
                                              <Arithmetic Operation="ADD">
                                                <ScalarOperator>
                                                  <Identifier>
                                                    <ColumnReference Column="Recr1012" />
                                                  </Identifier>
                                                </ScalarOperator>
                                                <ScalarOperator>
                                                  <Const ConstValue="(1)" />
                                                </ScalarOperator>
                                              </Arithmetic>
                                            </ScalarOperator>
                                          </DefinedValue>
                                        </DefinedValues>
                                        <RelOp NodeId="31" PhysicalOp="Nested Loops" LogicalOp="Inner Join" EstimateRows="7.37521" EstimateIO="0" EstimateCPU="3.18966e-005" AvgRowSize="92" EstimatedTotalSubtreeCost="0.124131" Parallel="0" EstimateRebinds="7.37521" EstimateRewinds="0">
                                          <OutputList>
                                            <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                            <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                                            <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="BOMLevel" />
                                            <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="PerAssemblyQty" />
                                            <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="Name" />
                                            <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="StandardCost" />
                                            <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="ListPrice" />
                                          </OutputList>
                                          <NestedLoops Optimized="0">
                                            <OuterReferences>
                                              <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                            </OuterReferences>
                                            <RelOp NodeId="32" PhysicalOp="Clustered Index Scan" LogicalOp="Clustered Index Scan" EstimateRows="7.63077" EstimateIO="0.0172776" EstimateCPU="0.0030254" AvgRowSize="38" EstimatedTotalSubtreeCost="0.0426159" TableCardinality="2679" Parallel="0" EstimateRebinds="0" EstimateRewinds="7.37521">
                                              <OutputList>
                                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="BOMLevel" />
                                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="PerAssemblyQty" />
                                              </OutputList>
                                              <IndexScan Ordered="0" ForcedIndex="0" NoExpandHint="0">
                                                <DefinedValues>
                                                  <DefinedValue>
                                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                                  </DefinedValue>
                                                  <DefinedValue>
                                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                                                  </DefinedValue>
                                                  <DefinedValue>
                                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="BOMLevel" />
                                                  </DefinedValue>
                                                  <DefinedValue>
                                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="PerAssemblyQty" />
                                                  </DefinedValue>
                                                </DefinedValues>
                                                <Object Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Index="[AK_BillOfMaterials_ProductAssemblyID_ComponentID_StartDate]" Alias="[b]" TableReferenceId="2" IndexKind="Clustered" />
                                                <Predicate>
                                                  <ScalarOperator ScalarString="[AdventureWorks].[Production].[BillOfMaterials].[ComponentID] as [b].[ComponentID]=[Recr1005] AND [@CheckDate]&gt;=[AdventureWorks].[Production].[BillOfMaterials].[StartDate] as [b].[StartDate] AND [@CheckDate]&lt;=isnull([AdventureWorks].[Production].[BillOfMaterials].[EndDate] as [b].[EndDate],[@CheckDate])">
                                                    <Logical Operation="AND">
                                                      <ScalarOperator>
                                                        <Compare CompareOp="EQ">
                                                          <ScalarOperator>
                                                            <Identifier>
                                                              <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ComponentID" />
                                                            </Identifier>
                                                          </ScalarOperator>
                                                          <ScalarOperator>
                                                            <Identifier>
                                                              <ColumnReference Column="Recr1005" />
                                                            </Identifier>
                                                          </ScalarOperator>
                                                        </Compare>
                                                      </ScalarOperator>
                                                      <ScalarOperator>
                                                        <Compare CompareOp="GE">
                                                          <ScalarOperator>
                                                            <Identifier>
                                                              <ColumnReference Column="@CheckDate" />
                                                            </Identifier>
                                                          </ScalarOperator>
                                                          <ScalarOperator>
                                                            <Identifier>
                                                              <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="StartDate" />
                                                            </Identifier>
                                                          </ScalarOperator>
                                                        </Compare>
                                                      </ScalarOperator>
                                                      <ScalarOperator>
                                                        <Compare CompareOp="LE">
                                                          <ScalarOperator>
                                                            <Identifier>
                                                              <ColumnReference Column="@CheckDate" />
                                                            </Identifier>
                                                          </ScalarOperator>
                                                          <ScalarOperator>
                                                            <Intrinsic FunctionName="isnull">
                                                              <ScalarOperator>
                                                                <Identifier>
                                                                  <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="EndDate" />
                                                                </Identifier>
                                                              </ScalarOperator>
                                                              <ScalarOperator>
                                                                <Identifier>
                                                                  <ColumnReference Column="@CheckDate" />
                                                                </Identifier>
                                                              </ScalarOperator>
                                                            </Intrinsic>
                                                          </ScalarOperator>
                                                        </Compare>
                                                      </ScalarOperator>
                                                    </Logical>
                                                  </ScalarOperator>
                                                </Predicate>
                                              </IndexScan>
                                            </RelOp>
                                            <RelOp NodeId="33" PhysicalOp="Clustered Index Seek" LogicalOp="Clustered Index Seek" EstimateRows="1" EstimateIO="0.003125" EstimateCPU="0.0001581" AvgRowSize="77" EstimatedTotalSubtreeCost="0.0502843" TableCardinality="504" Parallel="0" EstimateRebinds="62.9093" EstimateRewinds="0">
                                              <OutputList>
                                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="Name" />
                                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="StandardCost" />
                                                <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="ListPrice" />
                                              </OutputList>
                                              <IndexScan Ordered="1" ScanDirection="FORWARD" ForcedIndex="0" ForceSeek="0" NoExpandHint="0">
                                                <DefinedValues>
                                                  <DefinedValue>
                                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="Name" />
                                                  </DefinedValue>
                                                  <DefinedValue>
                                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="StandardCost" />
                                                  </DefinedValue>
                                                  <DefinedValue>
                                                    <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="ListPrice" />
                                                  </DefinedValue>
                                                </DefinedValues>
                                                <Object Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Index="[PK_Product_ProductID]" Alias="[p]" TableReferenceId="2" IndexKind="Clustered" />
                                                <SeekPredicates>
                                                  <SeekPredicateNew>
                                                    <SeekKeys>
                                                      <Prefix ScanType="EQ">
                                                        <RangeColumns>
                                                          <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[Product]" Alias="[p]" Column="ProductID" />
                                                        </RangeColumns>
                                                        <RangeExpressions>
                                                          <ScalarOperator ScalarString="[AdventureWorks].[Production].[BillOfMaterials].[ProductAssemblyID] as [b].[ProductAssemblyID]">
                                                            <Identifier>
                                                              <ColumnReference Database="[AdventureWorks]" Schema="[Production]" Table="[BillOfMaterials]" Alias="[b]" Column="ProductAssemblyID" />
                                                            </Identifier>
                                                          </ScalarOperator>
                                                        </RangeExpressions>
                                                      </Prefix>
                                                    </SeekKeys>
                                                  </SeekPredicateNew>
                                                </SeekPredicates>
                                              </IndexScan>
                                            </RelOp>
                                          </NestedLoops>
                                        </RelOp>
                                      </ComputeScalar>
                                    </RelOp>
                                  </NestedLoops>
                                </RelOp>
                                <Predicate>
                                  <ScalarOperator ScalarString="CASE WHEN [Expr1029]&gt;(25) THEN (0) ELSE NULL END">
                                    <IF>
                                      <Condition>
                                        <ScalarOperator>
                                          <Compare CompareOp="GT">
                                            <ScalarOperator>
                                              <Identifier>
                                                <ColumnReference Column="Expr1029" />
                                              </Identifier>
                                            </ScalarOperator>
                                            <ScalarOperator>
                                              <Const ConstValue="(25)" />
                                            </ScalarOperator>
                                          </Compare>
                                        </ScalarOperator>
                                      </Condition>
                                      <Then>
                                        <ScalarOperator>
                                          <Const ConstValue="(0)" />
                                        </ScalarOperator>
                                      </Then>
                                      <Else>
                                        <ScalarOperator>
                                          <Const ConstValue="NULL" />
                                        </ScalarOperator>
                                      </Else>
                                    </IF>
                                  </ScalarOperator>
                                </Predicate>
                              </Assert>
                            </RelOp>
                          </Concat>
                        </RelOp>
                      </Spool>
                    </RelOp>
                  </Sort>
                </RelOp>
              </StreamAggregate>
            </RelOp>
            <ParameterList>
              <ColumnReference Column="@CheckDate" ParameterCompiledValue="''2012-09-20 00:00:00.000''" />
              <ColumnReference Column="@StartProductID" ParameterCompiledValue="(1000)" />
            </ParameterList>
          </QueryPlan>
        </StmtSimple>
      </Statements>
    </Batch>
  </BatchSequence>
</ShowPlanXML>';

WITH xmlnamespaces (
    DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan'
)

select ColumnReference.query('.')
from @x.nodes(
    '/ShowPlanXML/BatchSequence/Batch/Statements/StmtSimple/QueryPlan/RelOp/StreamAggregate/RelOp/Sort/RelOp/Spool/RelOp/Concat/DefinedValues/DefinedValue/ColumnReference'
    ) as qp(ColumnReference);

WITH xmlnamespaces (
    DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan'
)

select ColumnReference.query('.')
from @x.nodes('//ColumnReference') as qp(ColumnReference)